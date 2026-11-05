import asyncio
from unittest.mock import patch, AsyncMock
from decimal import Decimal
from datetime import date
from starlette.requests import Request

from app.packages.p2_catalogo.controllers.cu010_ordenes_compra.purchase_controller import (
    is_localhost_request,
    LOCAL_NOTIFICATION_EMAIL_CU010,
)
from app.core.mail_service import MailService
from app.views.cu010_ordenes_compra.purchase_views import CompraResponse, CompraDetalleResponse


def test_is_localhost_request_detects_localhost():
    """Valida la detección correcta de localhost en varios escenarios."""
    # 1. Petición local estándar
    scope_local = {
        "type": "http",
        "headers": [(b"host", b"localhost:8000")],
        "server": ("127.0.0.1", 8000),
    }
    req_local = Request(scope_local)
    assert is_localhost_request(req_local) is True

    # 2. Petición con 127.0.0.1
    scope_ip = {
        "type": "http",
        "headers": [(b"host", b"127.0.0.1:8000")],
        "server": ("127.0.0.1", 8000),
    }
    req_ip = Request(scope_ip)
    assert is_localhost_request(req_ip) is True

    # 3. Petición proveniente de frontend local (Origin: http://localhost:4200)
    scope_origin = {
        "type": "http",
        "headers": [
            (b"host", b"api.example.com"),
            (b"origin", b"http://localhost:4200")
        ],
    }
    req_origin = Request(scope_origin)
    assert is_localhost_request(req_origin) is True

    # 4. Petición en producción / Railway (NO debe ser localhost)
    scope_railway = {
        "type": "http",
        "headers": [(b"host", b"grupo5si2-production-74df.up.railway.app")],
        "server": ("10.0.0.1", 80),
    }
    req_railway = Request(scope_railway)
    assert is_localhost_request(req_railway) is False

    # 5. Petición en Vercel
    scope_vercel = {
        "type": "http",
        "headers": [(b"host", b"frontend-sepia-seven-97.vercel.app")],
        "server": ("10.0.0.1", 80),
    }
    req_vercel = Request(scope_vercel)
    assert is_localhost_request(req_vercel) is False


def test_mail_service_renders_purchase_order():
    """Verifica que MailService renderice y prepare el correo para rafaelmontanoroca@gmail.com."""
    sample_compra = CompraResponse(
        idcompra=101,
        idtenant=1,
        idproveedor=5,
        proveedor_nombre="Apple Distribution Miami",
        numeroorden="OC-TEST-LOCAL-001",
        fechacompra=date(2026, 11, 5),
        totalusd=Decimal("2399.00"),
        estado="pendiente",
        total_items=2,
        detalles=[
            CompraDetalleResponse(
                idcompradetalle=1,
                idcompra=101,
                idvariante=10,
                sku="IP16PM-256-BLK",
                producto_nombre="iPhone 16 Pro Max",
                color="Titanio Negro",
                almacenamiento="256GB",
                cantidad=2,
                costounitariousd=Decimal("1199.50"),
                subtotalusd=Decimal("2399.00"),
            )
        ]
    )

    with patch("app.core.mail_service.send_email", new_callable=AsyncMock) as mock_send:
        mock_send.return_value = True

        result = asyncio.run(
            MailService.send_purchase_order_email(
                to_email=LOCAL_NOTIFICATION_EMAIL_CU010,
                compra=sample_compra,
                tenant_name="Importadora Apple Bolivia",
                environment_label="localhost"
            )
        )

        assert result is True
        mock_send.assert_called_once()
        call_kwargs = mock_send.call_args[1]

        assert call_kwargs["to_email"] == "rafaelmontanoroca@gmail.com"
        assert "OC-TEST-LOCAL-001" in call_kwargs["subject"]
        assert "iPhone 16 Pro Max" in call_kwargs["html_content"]
        assert "2399.00" in call_kwargs["html_content"]
        assert "Titanio Negro" in call_kwargs["html_content"]
        assert "localhost" in call_kwargs["html_content"]
