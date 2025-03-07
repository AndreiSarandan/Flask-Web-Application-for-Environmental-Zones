"""add min diesel and petrol to temp table

Revision ID: c4171f0e1c2d
Revises: 892f474fc82f
Create Date: 2024-03-23 17:05:23.052842

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'c4171f0e1c2d'
down_revision = '892f474fc82f'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('zone_temporary_data', schema=None) as batch_op:
        batch_op.add_column(sa.Column('tp_minimum_diesel', sa.Integer(), nullable=True))
        batch_op.add_column(sa.Column('tp_minimum_petrol', sa.Integer(), nullable=True))

    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('zone_temporary_data', schema=None) as batch_op:
        batch_op.drop_column('tp_minimum_petrol')
        batch_op.drop_column('tp_minimum_diesel')

    # ### end Alembic commands ###
