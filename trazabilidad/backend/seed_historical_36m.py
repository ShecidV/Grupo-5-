"""Pobla 36 meses de datos historicos por empresa (tenant) en la BD local.

Envoltorio delimitado de ``seed_historical_6m``: reutiliza toda la logica
determinista e idempotente (claves naturales ``HIST``) y solo cambia el rango
a 36 meses y el manifest. El manifest 36m se siembra con los IDs del manifest
6m para que ``--reset-history`` elimine tambien los meses generados antes.

Uso:
    python seed_historical_36m.py --dry-run
    python seed_historical_36m.py
    python seed_historical_36m.py --reset-history
"""
from __future__ import annotations

import json
from pathlib import Path

import seed_historical_6m as base

MESES = 36
MANIFEST = Path(__file__).with_name("seed_historical_36m.manifest.json")
MANIFEST_LEGACY = Path(__file__).with_name("seed_historical_6m.manifest.json")


def _sembrar_manifest_legacy() -> None:
    """Copia los IDs del manifest 6m al 36m la primera vez, sin duplicarlos."""
    if MANIFEST.exists() or not MANIFEST_LEGACY.exists():
        return
    try:
        datos = json.loads(MANIFEST_LEGACY.read_text(encoding="utf-8"))
        MANIFEST.write_text(json.dumps(datos, indent=2), encoding="utf-8")
        print(f"  Manifest 36m inicializado desde {MANIFEST_LEGACY.name}")
    except (OSError, ValueError) as exc:
        print(f"[AVISO] No se pudo migrar el manifest legacy: {exc}")


def main() -> int:
    _sembrar_manifest_legacy()
    return base.main(meses=MESES, manifest=str(MANIFEST))


if __name__ == "__main__":
    raise SystemExit(main())
