"""Seam P5 -> P6: notarización del evento de venta (eventType=5).

P5 solo conoce esta interfaz; la implementación de Web3 y el smart contract
permanecen encapsulados en P6. Es best-effort: si Blockchain no está
configurado, el registro queda 'pendiente' y la venta no se revierte.
"""
from typing import Iterable, Optional

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.controllers.shared import get_bolivia_now
from app.models.cu014_ubicaciones.location import Ubicacion
from app.models.cu021_eventos_transporte.transport_event import EventoTrazabilidad, EventoUnidad
from app.services.blockchain.registry_service import blockchain_registry


class SalesNotarizationService:
    @staticmethod
    def notarize_sale(
        db: Session,
        idtenant: int,
        idusuario: int,
        idventa: int,
        unidades: Iterable,
    ) -> Optional[EventoTrazabilidad]:
        ids_unidad = [u.idunidad for u in unidades]
        if not ids_unidad:
            return None

        ubicacion = db.execute(
            select(Ubicacion.idubicacion)
            .where(Ubicacion.idtenant == idtenant)
            .order_by(Ubicacion.idubicacion)
            .limit(1)
        ).scalar_one_or_none()
        if ubicacion is None:
            return None

        evento = EventoTrazabilidad(
            idtenant=idtenant,
            tipoevento="venta",
            fechahora=get_bolivia_now(),
            idubicacion=ubicacion,
            idusuarioresponsable=idusuario,
            descripcion=f"Venta #{idventa} notarizada desde el flujo comercial (CU-025).",
            estadoverificacion="pendiente",
        )
        db.add(evento)
        db.flush()
        for idunidad in ids_unidad:
            db.add(EventoUnidad(idevento=evento.idevento, idunidad=idunidad))
        evento.payloadhash = blockchain_registry.compute_payload_hash(evento)
        blockchain_registry.anchor_event(db, evento, commit=False)
        return evento


sales_notarization_service = SalesNotarizationService()
