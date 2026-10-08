from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import select

from app.db.session import get_db
from app.models.cu007_certificaciones.certification import Certificacion, ProductoCertificacion
from app.models.cu006_productos_variantes.product import Producto
from app.models.cu002_usuarios.user import User
from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.controllers.shared import require_roles
from app.views.cu007_certificaciones.certification_views import (
    CertificationCreate,
    CertificationUpdate,
    CertificationResponse,
    ProductCertificationAssign,
    ProductCertificationResponse
)

router = APIRouter(tags=["Gestionar Certificaciones Técnicas (CU-007)"])

# Roles autorizados a crear/editar/eliminar certificaciones y vincularlas a productos
# (certifications:manage en la matriz rol-permisos).
ROLES_GESTION_CERTIFICACION = ("SuperAdministrador", "AdministradorEmpresa")

requires_gestion_certificacion = require_roles(*ROLES_GESTION_CERTIFICACION)


class CertificationController:
    # 1. Listar todas las certificaciones registradas
    @staticmethod
    def list_certifications(db: Session) -> List[CertificationResponse]:
        stmt = select(Certificacion).order_by(Certificacion.idcertificacion.asc())
        certs = db.execute(stmt).scalars().all()
        return [CertificationResponse.model_validate(c) for c in certs]

    # 2. Crear una nueva certificación
    @staticmethod
    def create_certification(db: Session, data: CertificationCreate) -> CertificationResponse:
        cert = Certificacion(
            nombre=data.nombre,
            entidademisora=data.entidademisora,
            descripcion=data.descripcion,
            logourl=data.logourl
        )
        db.add(cert)
        db.commit()
        db.refresh(cert)
        return CertificationResponse.model_validate(cert)

    # 3. Editar una certificación existente
    @staticmethod
    def update_certification(db: Session, idcertificacion: int, data: CertificationUpdate) -> CertificationResponse:
        stmt = select(Certificacion).where(Certificacion.idcertificacion == idcertificacion)
        cert = db.execute(stmt).scalar_one_or_none()
        if not cert:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Certificación con ID {idcertificacion} no encontrada."
            )

        if data.nombre is not None:
            cert.nombre = data.nombre
        if data.entidademisora is not None:
            cert.entidademisora = data.entidademisora
        if data.descripcion is not None:
            cert.descripcion = data.descripcion
        if data.logourl is not None:
            cert.logourl = data.logourl

        db.commit()
        db.refresh(cert)
        return CertificationResponse.model_validate(cert)

    # 4. Eliminar una certificación por ID
    @staticmethod
    def delete_certification(db: Session, idcertificacion: int):
        stmt = select(Certificacion).where(Certificacion.idcertificacion == idcertificacion)
        cert = db.execute(stmt).scalar_one_or_none()
        if not cert:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Certificación con ID {idcertificacion} no encontrada."
            )

        db.delete(cert)
        db.commit()
        return {"detail": f"Certificación {idcertificacion} eliminada exitosamente."}

    # 5. Listar certificaciones asignadas a un producto
    @staticmethod
    def list_product_certifications(db: Session, idproducto: int) -> List[ProductCertificationResponse]:
        stmt = select(ProductoCertificacion).where(ProductoCertificacion.idproducto == idproducto)
        links = db.execute(stmt).scalars().all()
        return [ProductCertificationResponse.model_validate(l) for l in links]

    # 6. Asignar certificación a producto (valida existencia y previene duplicados)
    @staticmethod
    def assign_product_certification(db: Session, idproducto: int, data: ProductCertificationAssign) -> ProductCertificationResponse:
        # Verifica que el producto exista
        stmt_p = select(Producto).where(Producto.idproducto == idproducto)
        if not db.execute(stmt_p).scalar_one_or_none():
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Producto no encontrado.")

        # Verifica que la certificación exista
        stmt_c = select(Certificacion).where(Certificacion.idcertificacion == data.idcertificacion)
        if not db.execute(stmt_c).scalar_one_or_none():
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Certificación no encontrada.")

        # Evita asignar dos veces la misma certificación
        stmt_e = select(ProductoCertificacion).where(
            ProductoCertificacion.idproducto == idproducto,
            ProductoCertificacion.idcertificacion == data.idcertificacion
        )
        if db.execute(stmt_e).scalar_one_or_none():
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Esta certificación ya está asignada al producto.")

        link = ProductoCertificacion(
            idproducto=idproducto,
            idcertificacion=data.idcertificacion,
            fechaobtencion=data.fechaobtencion
        )
        db.add(link)
        db.commit()
        db.refresh(link)
        return ProductCertificationResponse.model_validate(link)

    # 7. Quitar certificación de un producto
    @staticmethod
    def remove_product_certification(db: Session, idproducto: int, idcertificacion: int):
        stmt = select(ProductoCertificacion).where(
            ProductoCertificacion.idproducto == idproducto,
            ProductoCertificacion.idcertificacion == idcertificacion
        )
        link = db.execute(stmt).scalar_one_or_none()
        if not link:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Asignación no encontrada.")

        db.delete(link)
        db.commit()
        return {"detail": "Certificación removida del producto."}


# Endpoints API REST

@router.get("/certifications", response_model=List[CertificationResponse])
def get_certifications(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Listar certificaciones disponibles."""
    return CertificationController.list_certifications(db)


@router.post("/certifications", response_model=CertificationResponse, status_code=status.HTTP_201_CREATED)
def create_certification(
    data: CertificationCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_certificacion)
):
    """Registrar nueva certificación."""
    return CertificationController.create_certification(db, data)


@router.put("/certifications/{idcertificacion}", response_model=CertificationResponse)
def update_certification(
    idcertificacion: int,
    data: CertificationUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_certificacion)
):
    """Editar certificación."""
    return CertificationController.update_certification(db, idcertificacion, data)


@router.delete("/certifications/{idcertificacion}")
def delete_certification(
    idcertificacion: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_certificacion)
):
    """Eliminar certificación."""
    return CertificationController.delete_certification(db, idcertificacion)


# Asignación a productos

@router.get("/products/{idproducto}/certifications", response_model=List[ProductCertificationResponse])
def get_product_certifications(
    idproducto: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Ver certificaciones de un producto."""
    return CertificationController.list_product_certifications(db, idproducto)


@router.post("/products/{idproducto}/certifications", response_model=ProductCertificationResponse, status_code=201)
def assign_product_certification(
    idproducto: int,
    data: ProductCertificationAssign,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_certificacion)
):
    """Asignar certificación a un producto."""
    return CertificationController.assign_product_certification(db, idproducto, data)


@router.delete("/products/{idproducto}/certifications/{idcertificacion}")
def remove_product_certification(
    idproducto: int,
    idcertificacion: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(requires_gestion_certificacion)
):
    """Desvincular certificación de un producto."""
    return CertificationController.remove_product_certification(db, idproducto, idcertificacion)
