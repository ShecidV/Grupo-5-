"""Notificaciones de facturación y suscripción (CU-040)."""
from datetime import timedelta
from typing import List, Optional

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.controllers.shared import get_bolivia_now
from app.models.cu002_usuarios.usuario_tenant import UsuarioTenant
from app.models.cu005_bitacora.notification import Notificacion
from app.packages.p8_suscripciones.models.cu036_planes.subscription_models import Suscripcion
from app.packages.p8_suscripciones.models.cu039_facturacion.factura import Factura
from app.services.push_gateway import push_gateway

PREFIJO = "[Facturación]"


class BillingNotifier:
    @staticmethod
    def notificar_factura_emitida(db: Session, factura: Factura) -> int:
        return push_gateway.notify_tenant(
            db, factura.idtenant,
            f"{PREFIJO} Nueva factura {factura.numero}",
            f"Se emitió la factura {factura.numero} por {factura.monto} {factura.moneda}.",
            enlaceaccion=f"/billing/invoices/{factura.idfactura}",
        )

    @staticmethod
    def notificar_cobro(db: Session, factura: Factura, monto) -> int:
        return push_gateway.notify_tenant(
            db, factura.idtenant,
            f"{PREFIJO} Pago registrado {factura.numero}",
            f"Se registró un cobro de {monto} {factura.moneda} para la factura {factura.numero}.",
            enlaceaccion=f"/billing/invoices/{factura.idfactura}",
        )

    @staticmethod
    def notificar_cuota_excedida(db: Session, idtenant: int, concepto: str) -> int:
        return push_gateway.notify_tenant(
            db, idtenant,
            f"{PREFIJO} Límite de plan alcanzado",
            f"Se alcanzó el límite de {concepto} de su plan de suscripción.",
            enlaceaccion="/quotas",
        )

    @staticmethod
    def procesar_programadas(
        db: Session,
        diasanticipacion: int = 7,
        incluirvencidas: bool = True,
        idtenant: Optional[int] = None,
    ) -> List[dict]:
        """Procesa vencimientos de suscripción y facturas pendientes.

        Cuando se indica ``idtenant`` se procesa únicamente esa empresa
        (ADR-001: aislamiento multi-tenant). Sin él, el método procesa todas
        las empresas y queda reservado al scheduler externo (cron / Cloud
        Scheduler) que se autentica como SuperAdministrador con bypass.
        """
        ahora = get_bolivia_now()
        limite = ahora + timedelta(days=diasanticipacion)
        eventos: List[dict] = []

        filtro_tenant = [Suscripcion.idtenant == idtenant] if idtenant is not None else []
        suscripciones = db.execute(
            select(Suscripcion).where(
                Suscripcion.estado.in_(["trial", "activa"]),
                Suscripcion.fechafin >= ahora,
                Suscripcion.fechafin <= limite,
                *filtro_tenant,
            )
        ).scalars().all()
        for sus in suscripciones:
            enviados = push_gateway.notify_tenant(
                db, sus.idtenant,
                f"{PREFIJO} Suscripción por vencer",
                f"Su suscripción vence el {sus.fechafin:%Y-%m-%d}. Renueve para evitar la suspensión.",
                enlaceaccion="/subscription",
            )
            eventos.append({
                "id": f"suscripcion-{sus.idsuscripcion}",
                "tipo": "suscripcion_por_vencer",
                "titulo": f"{PREFIJO} Suscripción por vencer",
                "contenido": f"Vence el {sus.fechafin:%Y-%m-%d}.",
                "destinatarios": enviados,
                "enviadoen": ahora,
            })

        if incluirvencidas:
            vencidas = db.execute(
                select(Suscripcion).where(
                    Suscripcion.estado.in_(["trial", "activa"]),
                    Suscripcion.fechafin < ahora,
                    *filtro_tenant,
                )
            ).scalars().all()
            for sus in vencidas:
                sus.estado = "vencida"
                enviados = push_gateway.notify_tenant(
                    db, sus.idtenant,
                    f"{PREFIJO} Suscripción vencida",
                    "Su suscripción ha vencido. Regularice el pago para reactivar el servicio.",
                    enlaceaccion="/subscription",
                )
                eventos.append({
                    "id": f"suscripcion-vencida-{sus.idsuscripcion}",
                    "tipo": "suscripcion_vencida",
                    "titulo": f"{PREFIJO} Suscripción vencida",
                    "contenido": "La suscripción ha vencido.",
                    "destinatarios": enviados,
                    "enviadoen": ahora,
                })

        filtro_factura = [Factura.idtenant == idtenant] if idtenant is not None else []
        facturas = db.execute(
            select(Factura).where(
                Factura.estado == "pendiente",
                Factura.fechavencimiento <= limite,
                *filtro_factura,
            )
        ).scalars().all()
        for factura in facturas:
            enviados = push_gateway.notify_tenant(
                db, factura.idtenant,
                f"{PREFIJO} Factura por vencer",
                f"La factura {factura.numero} vence el {factura.fechavencimiento:%Y-%m-%d}.",
                enlaceaccion=f"/billing/invoices/{factura.idfactura}",
            )
            eventos.append({
                "id": f"factura-{factura.idfactura}",
                "tipo": "factura_por_vencer",
                "titulo": f"{PREFIJO} Factura por vencer",
                "contenido": f"Vence el {factura.fechavencimiento:%Y-%m-%d}.",
                "destinatarios": enviados,
                "enviadoen": ahora,
            })

        db.commit()
        return eventos

    @staticmethod
    def historial(db: Session, idtenant: int) -> List[Notificacion]:
        idut = db.execute(
            select(UsuarioTenant.idusuariotenant).where(UsuarioTenant.idtenant == idtenant)
        ).scalars().all()
        if not idut:
            return []
        return db.execute(
            select(Notificacion)
            .where(
                Notificacion.idusuariotenant.in_(idut),
                Notificacion.enlaceaccion.like("/billing%")
                | Notificacion.enlaceaccion.like("/quotas%")
                | Notificacion.enlaceaccion.like("/subscription%"),
            )
            .order_by(Notificacion.fechaenvio.desc())
        ).scalars().all()


billing_notifier = BillingNotifier()
