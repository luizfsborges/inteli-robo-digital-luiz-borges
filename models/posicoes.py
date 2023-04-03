from models.base import Base
from sqlalchemy import Column, Integer

class Posicoes(Base):

    # Nome da tabela
    __tablename__ = "Posicoes"

    # Colunas
    id = Column(Integer, primary_key=True)
    x = Column(Integer)
    y = Column(Integer)
    z = Column(Integer)