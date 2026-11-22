import unicodedata

from fastapi import APIRouter, Depends, HTTPException, Query, status
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.controllers.shared import resolve_tenant_id
from app.controllers.cu004_autenticacion.auth_controller import get_current_user
from app.models.cu002_usuarios.user import User
from app.views.cu022_ia.ai_schemas import VoiceQueryRequest, VoiceReportResponse
from app.services.ai.voice_query_engine import process_voice_query, REPORT_CACHE
from app.services.ai.report_generator import generate_pdf_bytes, generate_excel_bytes

router = APIRouter(prefix="/ai", tags=["Inteligencia Artificial y Reportes por Voz (CU-022)"])


@router.post("/voice-report", response_model=VoiceReportResponse)
def generate_voice_report(
    payload: VoiceQueryRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """
    Procesa un comando de voz / texto en lenguaje natural, consulta la base de datos
    restringiendo por el tenant del usuario y genera un informe dinámico con KPIs,
    gráficos interactivos y enlaces de descarga oficial en PDF y Excel.
    """
    # ADR-001/005: empresa activa del JWT, vínculos del usuario y bypass SuperAdmin.
    tenant_id = resolve_tenant_id(db=db, user=current_user)

    report_dict = process_voice_query(
        db=db,
        tenant_id=tenant_id,
        query=payload.query,
        context=payload.context,
        user_email=current_user.email,
    )

    return VoiceReportResponse(**report_dict)


@router.get("/reports/{report_id}/export")
def export_report_document(
    report_id: str,
    format: str = Query("pdf", pattern="^(pdf|excel)$"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """
    Descarga el informe dinámico en PDF o Excel desde el snapshot en memoria.
    El snapshot solo puede descargarlo la empresa que lo generó (ADR-001).
    """
    cached = REPORT_CACHE.get(report_id)
    if not cached:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="El reporte solicitado no existe o ha expirado. Por favor genera una nueva consulta.",
        )
    if cached.get("tenant_id") != resolve_tenant_id(db=db, user=current_user):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="El reporte solicitado no existe o ha expirado. Por favor genera una nueva consulta.",
        )

    title = cached.get("title", "Reporte")
    ascii_title = unicodedata.normalize("NFKD", title).encode("ascii", "ignore").decode("ascii")
    safe_title = (
        "".join(c for c in ascii_title if c.isalnum() or c in (" ", "_", "-"))
        .strip()
        .replace(" ", "_")
        or "Reporte"
    )

    if format == "excel":
        excel_buf = generate_excel_bytes(
            report_title=cached.get("title", "Reporte"),
            tenant_name=cached.get("tenant_name", "Empresa"),
            tenant_nit=cached.get("tenant_nit", "NIT"),
            voice_summary=cached.get("voice_summary", ""),
            executive_summary=cached.get("executive_summary", ""),
            kpis=cached.get("kpis", []),
            table_headers=cached.get("table_headers", []),
            table_rows=cached.get("table_rows", []),
            generated_at=cached.get("generated_at", ""),
            user_email=cached.get("user_email", "Admin"),
            period_label=cached.get("period_label", ""),
            interpretation=cached.get("interpretation", ""),
            product_detail=cached.get("product_detail"),
        )
        return StreamingResponse(
            excel_buf,
            media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            headers={"Content-Disposition": f'attachment; filename="reporte_{safe_title}.xlsx"'},
        )
    else:
        pdf_buf = generate_pdf_bytes(
            report_title=cached.get("title", "Reporte"),
            tenant_name=cached.get("tenant_name", "Empresa"),
            tenant_nit=cached.get("tenant_nit", "NIT"),
            voice_summary=cached.get("voice_summary", ""),
            executive_summary=cached.get("executive_summary", ""),
            kpis=cached.get("kpis", []),
            table_headers=cached.get("table_headers", []),
            table_rows=cached.get("table_rows", []),
            generated_at=cached.get("generated_at", ""),
            user_email=cached.get("user_email", "Admin"),
            period_label=cached.get("period_label", ""),
            interpretation=cached.get("interpretation", ""),
            product_detail=cached.get("product_detail"),
        )
        return StreamingResponse(
            pdf_buf,
            media_type="application/pdf",
            headers={"Content-Disposition": f'attachment; filename="reporte_{safe_title}.pdf"'},
        )
