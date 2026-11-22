"""CU-034 - Consultar Registros Blockchain y Certificados.

Consolida, para una unidad, los registros de trazabilidad anclados en Blockchain
(Fase 1-2 / CU-033), las certificaciones técnicas de su producto (CU-007) y los
documentos adjuntos (CU-032), y genera un certificado digital de trazabilidad
respaldado por dichos registros. Disponible para el personal autorizado y, en
modo lectura por UUID público, para el consumidor (móvil).
"""

import hashlib
import json
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.models.cu001_tenants.tenant import Tenant
from app.models.cu002_usuarios.user import User
from app.models.cu006_productos_variantes.product import Producto
from app.models.cu006_productos_variantes.variant import VarianteProducto
from app.models.cu007_certificaciones.certification import Certificacion, ProductoCertificacion
from app.models.cu015_unidades_producto.unit import UnidadProducto
from app.models.cu016_codigos_qr.qr_code import CodigoQR
from app.models.cu021_eventos_transporte.transport_event import EventoTrazabilidad, EventoUnidad
from app.models.cu032_documentos_unidad.documento_unidad import DocumentoUnidad
from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import get_bolivia_now, require_roles, resolve_tenant_id
from app.services.blockchain.registry_service import blockchain_registry
from app.views.cu033_blockchain.blockchain_views import RegistroBlockchainResponse
from app.views.cu034_certificados.certificate_views import (
    CertificacionUnidad,
    DigitalCertificateResponse,
    DocumentoCertificado,
    EventoCertificado,
    UnitCertificateResponse,
)

router = APIRouter(prefix="/certificates", tags=["Certificados y Blockchain (CU-034)"])

ROLES_CERTIFICADOS = (
    "SuperAdministrador",
    "AdministradorEmpresa",
    "GestorOperaciones",
    "Auditor",
)
requires_certificados = require_roles(*ROLES_CERTIFICADOS)


class CertificateController:

    # ── Resolución de la unidad ────────────────────────────────────────────
    @staticmethod
    def _get_unidad_por_id(db: Session, tenant_id: int, idunidad: int) -> UnidadProducto:
        unidad = db.execute(
            select(UnidadProducto).where(
                UnidadProducto.idunidad == idunidad,
                UnidadProducto.idtenant == tenant_id,
            )
        ).scalar_one_or_none()
        if not unidad:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"La unidad con ID {idunidad} no existe en su empresa.",
            )
        return unidad

    @staticmethod
    def _get_unidad_por_uuid(db: Session, uuidpublico: str) -> UnidadProducto:
        unidad = db.execute(
            select(UnidadProducto).where(UnidadProducto.uuidpublico == uuidpublico)
        ).scalar_one_or_none()
        if not unidad:
            qr = db.execute(
                select(CodigoQR).where(
                    (CodigoQR.tokenpublico == uuidpublico) | (CodigoQR.url.like(f"%{uuidpublico}%")),
                    CodigoQR.activo == True,
                )
            ).scalars().first()
            if qr:
                unidad = db.execute(
                    select(UnidadProducto).where(UnidadProducto.idunidad == qr.idunidad)
                ).scalar_one_or_none()
        if not unidad:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND, detail="Unidad no encontrada."
            )
        return unidad

    # ── Construcción del certificado ───────────────────────────────────────
    @staticmethod
    def _producto_info(
        db: Session, unidad: UnidadProducto
    ) -> tuple[Optional[Producto], Optional[VarianteProducto]]:
        variante = db.execute(
            select(VarianteProducto).where(VarianteProducto.idvariante == unidad.idvariante)
        ).scalar_one_or_none()
        producto = None
        if variante:
            producto = db.execute(
                select(Producto).where(Producto.idproducto == variante.idproducto)
            ).scalar_one_or_none()
        return producto, variante

    @staticmethod
    def _eventos(db: Session, idunidad: int) -> list[EventoCertificado]:
        eventos = db.execute(
            select(EventoTrazabilidad)
            .join(EventoUnidad, EventoUnidad.idevento == EventoTrazabilidad.idevento)
            .where(EventoUnidad.idunidad == idunidad)
            .order_by(EventoTrazabilidad.fechahora.asc())
        ).scalars().all()

        resultado = []
        for ev in eventos:
            registro = blockchain_registry.get_registro(db, ev.idevento)
            confirmado = registro is not None and str(registro.estado) == "confirmado"
            verificado = (
                confirmado
                and bool(ev.payloadhash)
                and registro.payloadhash == ev.payloadhash
            )
            resultado.append(
                EventoCertificado(
                    idevento=ev.idevento,
                    tipoevento=str(ev.tipoevento),
                    fechahora=ev.fechahora,
                    descripcion=ev.descripcion,
                    payloadhash=ev.payloadhash,
                    estadoverificacion=str(ev.estadoverificacion) if ev.estadoverificacion else None,
                    registro_blockchain=(
                        RegistroBlockchainResponse.model_validate(registro) if registro else None
                    ),
                    en_blockchain=confirmado,
                    verificado=verificado,
                )
            )
        return resultado

    @staticmethod
    def _certificaciones(db: Session, producto: Optional[Producto]) -> list[CertificacionUnidad]:
        if not producto:
            return []
        rows = db.execute(
            select(Certificacion, ProductoCertificacion.fechaobtencion)
            .join(ProductoCertificacion, ProductoCertificacion.idcertificacion == Certificacion.idcertificacion)
            .where(ProductoCertificacion.idproducto == producto.idproducto)
        ).all()
        return [
            CertificacionUnidad(
                idcertificacion=cert.idcertificacion,
                nombre=cert.nombre,
                entidademisora=cert.entidademisora,
                descripcion=cert.descripcion,
                fechaobtencion=fecha,
            )
            for cert, fecha in rows
        ]

    @staticmethod
    def _documentos(db: Session, idunidad: int) -> list[DocumentoCertificado]:
        docs = db.execute(
            select(DocumentoUnidad)
            .where(DocumentoUnidad.idunidad == idunidad)
            .order_by(DocumentoUnidad.iddocumento.desc())
        ).scalars().all()
        return [
            DocumentoCertificado(
                iddocumento=d.iddocumento,
                nombre=d.nombre,
                tipodocumento=str(d.tipodocumento),
                urlarchivo=d.urlarchivo,
                hasharchivo=d.hasharchivo,
                fechaemision=d.fechaemision,
                fechavencimiento=d.fechavencimiento,
            )
            for d in docs
        ]

    @staticmethod
    def _autenticidad(eventos: list[EventoCertificado]) -> str:
        if not eventos:
            return "sin_datos"
        if any(ev.en_blockchain for ev in eventos):
            return "verificado"
        return "registrado"

    @classmethod
    def _build_certificate(cls, db: Session, unidad: UnidadProducto) -> UnitCertificateResponse:
        producto, variante = cls._producto_info(db, unidad)
        eventos = cls._eventos(db, unidad.idunidad)
        documentos = cls._documentos(db, unidad.idunidad)
        certificaciones = cls._certificaciones(db, producto)

        return UnitCertificateResponse(
            idunidad=unidad.idunidad,
            numeroserie=unidad.numeroserie,
            uuidpublico=unidad.uuidpublico,
            producto=producto.nombre if producto else None,
            modelo=producto.modelo if producto else None,
            sku=variante.sku if variante else None,
            color=variante.color if variante else None,
            capacidad=variante.capacidad if variante else None,
            autenticidad=cls._autenticidad(eventos),
            total_eventos=len(eventos),
            eventos=eventos,
            certificaciones=certificaciones,
            documentos=documentos,
            registros_blockchain=len(eventos),
            registros_confirmados=sum(1 for ev in eventos if ev.en_blockchain),
        )

    # ── Casos de uso ───────────────────────────────────────────────────────
    @staticmethod
    def get_unit_certificate(db: Session, user: User, idunidad: int) -> UnitCertificateResponse:
        tenant_id = resolve_tenant_id(db, user)
        unidad = CertificateController._get_unidad_por_id(db, tenant_id, idunidad)
        return CertificateController._build_certificate(db, unidad)

    @staticmethod
    def get_public_certificate(db: Session, uuidpublico: str) -> UnitCertificateResponse:
        unidad = CertificateController._get_unidad_por_uuid(db, uuidpublico)
        return CertificateController._build_certificate(db, unidad)

    @staticmethod
    def generate_digital_certificate(
        db: Session, user: User, idunidad: int
    ) -> DigitalCertificateResponse:
        tenant_id = resolve_tenant_id(db, user)
        unidad = CertificateController._get_unidad_por_id(db, tenant_id, idunidad)
        consolidado = CertificateController._build_certificate(db, unidad)

        emitido_por = user.nombrecompleto
        tenant = db.execute(
            select(Tenant).where(Tenant.idtenant == unidad.idtenant)
        ).scalar_one_or_none()
        if tenant:
            emitido_por = f"{emitido_por} ({tenant.nombre})"

        return CertificateController._build_digital(consolidado, emitido_por)

    @staticmethod
    def _build_digital(
        consolidado: UnitCertificateResponse, emitido_por: Optional[str]
    ) -> DigitalCertificateResponse:
        generado = get_bolivia_now()
        payload = {
            "idunidad": consolidado.idunidad,
            "numeroserie": consolidado.numeroserie,
            "uuidpublico": consolidado.uuidpublico,
            "producto": consolidado.producto,
            "autenticidad": consolidado.autenticidad,
            "eventos": [
                {
                    "idevento": ev.idevento,
                    "tipoevento": ev.tipoevento,
                    "fechahora": ev.fechahora.isoformat() if ev.fechahora else None,
                    "payloadhash": ev.payloadhash,
                }
                for ev in consolidado.eventos
            ],
            "certificaciones": [c.nombre for c in consolidado.certificaciones],
            "documentos": [d.iddocumento for d in consolidado.documentos],
            "fechageneracion": generado.isoformat(),
        }
        raw = json.dumps(payload, sort_keys=True, ensure_ascii=False, separators=(",", ":"))
        hashcertificado = hashlib.sha256(raw.encode("utf-8")).hexdigest()
        codigo = f"CERT-{consolidado.numeroserie}-{hashcertificado[:10].upper()}"

        return DigitalCertificateResponse(
            idunidad=consolidado.idunidad,
            numeroserie=consolidado.numeroserie,
            uuidpublico=consolidado.uuidpublico,
            producto=consolidado.producto,
            sku=consolidado.sku,
            codigocertificado=codigo,
            fechageneracion=generado,
            hashcertificado=hashcertificado,
            autenticidad=consolidado.autenticidad,
            total_eventos=consolidado.total_eventos,
            eventos_verificados=sum(1 for ev in consolidado.eventos if ev.verificado),
            documentos=len(consolidado.documentos),
            certificaciones=[c.nombre for c in consolidado.certificaciones],
            emitido_por=emitido_por,
            mensaje=(
                "Certificado generado a partir de los registros de trazabilidad de la unidad."
            ),
        )


# Endpoints API REST

@router.get("/units/{idunidad}", response_model=UnitCertificateResponse)
def get_unit_certificate_route(
    idunidad: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_certificados),
):
    """Registros Blockchain + certificaciones + documentos de una unidad (CU-034)."""
    return CertificateController.get_unit_certificate(db, current_user, idunidad)


@router.get("/units/{idunidad}/digital", response_model=DigitalCertificateResponse)
def generate_digital_certificate_route(
    idunidad: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_certificados),
):
    """Genera el certificado digital de trazabilidad de una unidad (CU-034)."""
    return CertificateController.generate_digital_certificate(db, current_user, idunidad)


@router.get("/public/{uuidpublico}", response_model=UnitCertificateResponse)
def get_public_certificate_route(uuidpublico: str, db: Session = Depends(get_db)):
    """Consulta pública (lectura) de certificados y registros por UUID (CU-034)."""
    return CertificateController.get_public_certificate(db, uuidpublico)
