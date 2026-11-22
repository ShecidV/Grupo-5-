"""tablas sprint4 facturacion cuotas

Revision ID: f1a2b3c4d5e6
Revises: 83c5ca311fb6
Create Date: 2026-11-19
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = 'f1a2b3c4d5e6'
down_revision: Union[str, Sequence[str], None] = '83c5ca311fb6'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        'usoplan',
        sa.Column('iduso', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('idtenant', sa.Integer(), sa.ForeignKey('tenant.idtenant'), nullable=False),
        sa.Column('periodo', sa.String(length=7), nullable=False),
        sa.Column('reportesgenerados', sa.Integer(), server_default='0', nullable=False),
        sa.Column('unidadesregistradas', sa.Integer(), server_default='0', nullable=False),
        sa.Column('usuariosactivos', sa.Integer(), server_default='0', nullable=False),
        sa.Column('actualizadoen', sa.DateTime(), nullable=False),
        sa.PrimaryKeyConstraint('iduso'),
        sa.UniqueConstraint('idtenant', 'periodo', name='uq_usoplan_tenant_periodo'),
    )
    op.create_index('ix_usoplan_idtenant', 'usoplan', ['idtenant'])

    op.create_table(
        'factura',
        sa.Column('idfactura', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('idtenant', sa.Integer(), sa.ForeignKey('tenant.idtenant'), nullable=False),
        sa.Column('idsuscripcion', sa.Integer(), sa.ForeignKey('suscripcion.idsuscripcion'), nullable=True),
        sa.Column('numero', sa.String(length=32), nullable=False),
        sa.Column('fechaemision', sa.DateTime(), nullable=False),
        sa.Column('fechavencimiento', sa.DateTime(), nullable=False),
        sa.Column('monto', sa.Numeric(12, 2), nullable=False),
        sa.Column('moneda', sa.String(length=3), server_default='USD', nullable=False),
        sa.Column('estado', sa.String(length=20), server_default='pendiente', nullable=False),
        sa.PrimaryKeyConstraint('idfactura'),
        sa.UniqueConstraint('idtenant', 'numero', name='uq_factura_tenant_numero'),
    )
    op.create_index('ix_factura_idtenant', 'factura', ['idtenant'])

    op.create_table(
        'facturadetalle',
        sa.Column('idfacturadetalle', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('idfactura', sa.Integer(), sa.ForeignKey('factura.idfactura'), nullable=False),
        sa.Column('concepto', sa.String(length=200), nullable=False),
        sa.Column('cantidad', sa.Integer(), server_default='1', nullable=False),
        sa.Column('preciounitario', sa.Numeric(12, 2), nullable=False),
        sa.Column('subtotal', sa.Numeric(12, 2), nullable=False),
        sa.PrimaryKeyConstraint('idfacturadetalle'),
    )

    op.create_table(
        'cobro',
        sa.Column('idcobro', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('idfactura', sa.Integer(), sa.ForeignKey('factura.idfactura'), nullable=False),
        sa.Column('fechacobro', sa.DateTime(), nullable=False),
        sa.Column('monto', sa.Numeric(12, 2), nullable=False),
        sa.Column('metodopago', sa.String(length=40), nullable=False),
        sa.Column('referencia', sa.String(length=100), nullable=True),
        sa.Column('estado', sa.String(length=20), server_default='completado', nullable=False),
        sa.PrimaryKeyConstraint('idcobro'),
    )

    # Unicidad física para evitar que una unidad se asigne dos veces (P5).
    for table, constraint in (
        ('ventaunidad', 'uq_ventaunidad_idunidad'),
        ('devolucionunidad', 'uq_devolucionunidad_idunidad'),
        ('garantiaunidad', 'uq_garantiaunidad_idunidad'),
    ):
        op.create_unique_constraint(constraint, table, ['idunidad'])


def downgrade() -> None:
    for table, constraint in (
        ('garantiaunidad', 'uq_garantiaunidad_idunidad'),
        ('devolucionunidad', 'uq_devolucionunidad_idunidad'),
        ('ventaunidad', 'uq_ventaunidad_idunidad'),
    ):
        op.drop_unique_constraint(constraint, table)
    op.drop_table('cobro')
    op.drop_table('facturadetalle')
    op.drop_index('ix_factura_idtenant', table_name='factura')
    op.drop_table('factura')
    op.drop_index('ix_usoplan_idtenant', table_name='usoplan')
    op.drop_table('usoplan')
