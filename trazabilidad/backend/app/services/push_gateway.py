"""Puerta de notificaciones push (CU-005 / CU-040).

Implementación por defecto sin proveedor externo: las notificaciones quedan
registradas en la tabla `notificacion` (in-app) y el envío push es un no-op.
Cuando se configure Firebase/APNs se sustituye la implementación sin tocar los
controladores.
"""
from typing import Callable, List, Optional
from datetime import datetime

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models.cu002_usuarios.usuario_tenant import UsuarioTenant
from app.models.cu005_bitacora.notification import Notificacion

# Los proveedores externos (FCM/APNs) se registran aquí en el arranque de la app.
# Cada proveedor recibe (idtenant, titulo, contenido, enlaceaccion) y puede ser
# un no-op hasta configurar credenciales.
PushProvider = Callable[[int, str, str, Optional[str]], None]
_push_providers: List[PushProvider] = []


def register_push_provider(provider: PushProvider) -> None:
    _push_providers.append(provider)


class PushGateway:
    @staticmethod
    def notify_tenant(
        db: Session,
        idtenant: int,
        titulo: str,
        contenido: str,
        enlaceaccion: Optional[str] = None,
        max_usuarios: int = 50,
    ) -> int:
        idut_list = db.execute(
            select(UsuarioTenant.idusuariotenant)
            .where(UsuarioTenant.idtenant == idtenant)
            .limit(max_usuarios)
        ).scalars().all()
        for idut in idut_list:
            db.add(
                Notificacion(
                    idusuariotenant=idut,
                    titulo=titulo[:100],
                    contenido=contenido,
                    leida=False,
                    fechaenvio=datetime.utcnow(),
                    enlaceaccion=enlaceaccion,
                )
            )
        for proveedor in _push_providers:
            proveedor(idtenant, titulo[:100], contenido, enlaceaccion)
        return len(idut_list)


push_gateway = PushGateway()
