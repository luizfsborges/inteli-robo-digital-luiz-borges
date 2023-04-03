# Importação de bibliotecas
import asyncio
import websockets
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from models.base import Base
from models.posicoes import Posicoes

# Criação do banco de dados
engine = create_engine("sqlite+pysqlite:///posicoes.db", echo=True)

# Criação da sessão
Session = sessionmaker(bind=engine)
session = Session()

# Criação das tabelas
Base.metadata.create_all(engine)

# Inserção de dados
session.commit()

# Função de extração de coordenadas numéricas da mensagem recebida
def processa_coordenadas(mensagem_recebida):
    coordenadas = mensagem_recebida.strip('"').split(":")
    
    print(coordenadas)
    dict_coordenadas = {"X": coordenadas[1], "Y": coordenadas[3], "Z": coordenadas[5]}
    print(dict_coordenadas)
    return dict_coordenadas

# Função de armazenamento das coordenadas no banco de dados
def armazena_coordenadas(coordenada_x, coordenada_y, coordenada_z):
     
    coordenadas = Posicoes(x=coordenada_x, y=coordenada_y, z=coordenada_z)
    session.add(coordenadas)
    session.commit()

    return None

# Função de exibição das coordenadas armazenadas no banco de dados
def exibe_coordenadas():
    # Listagem de dados
    coordenadas = session.query(Posicoes).all()
    print("\n[COORDENADAS CADASTRADAS]\n")

    for coordenada in coordenadas:
        print("X: ", coordenada.x, " | Y: ", coordenada.y, " | Z: ", coordenada.z)

    return None

# Função de execução do servidor
async def server(websocket, path):
    print("\nUm cliente acabou de se conectar")
    try:
        async for mensagem in websocket:
            # Decodifica a mensagem recebida
            mensagem_recebida = mensagem.decode("UTF-8")            
            print(f"\nMensagem recebida do cliente: {mensagem_recebida}")
            # Processa a mensagem recebida e armazena as coordenadas no banco de dados
            dict_deslocamento_garra = processa_coordenadas(mensagem_recebida)
            print(f"\nDeslocamento da garra: {dict_deslocamento_garra}")

            armazena_coordenadas(dict_deslocamento_garra["X"], 
                                 dict_deslocamento_garra["Y"], 
                                 dict_deslocamento_garra["Z"])
            print("\nCoordenadas armazenadas no banco de dados")
            
            # Envia as coordenadas de deslocamento do robo para o cliente
            await websocket.send(mensagem_recebida)
            print(f"\nCoordenadas de deslocamento enviadas para o cliente: {mensagem_recebida}")

            # Exibe todas as coordenadas armazenadas no banco de dados
            exibe_coordenadas()
    
    # Tratamento de exceção de conexão encerrada
    except websockets.exceptions.ConnectionClosed as e:
        print("\nUm cliente acabou de se desconectar")

# Especifica a porta do servidor
PORTA_SERVIDOR = 5000

# Rotina principal de execução do servidor e chamada das funções
def main():
    start_server = websockets.serve(server, "localhost", 5000)
    asyncio.get_event_loop().run_until_complete(start_server)
    print(f"\nServidor iniciado na porta {PORTA_SERVIDOR}")
    asyncio.get_event_loop().run_forever()
    
# Executa a função main
if __name__ == "__main__":
    main()