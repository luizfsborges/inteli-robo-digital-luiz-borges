import asyncio
import websockets

dict_deslocamento = {"X": [], "Y": [], "Z": []}

def armazena_coordenadas(mensagem_recebida, dict_coordenadas):
    # Recebe uma mensagem do tipo "X:coordanda:Y:coordenada:Z:coordenada" e armazena os valores em uma lista
    
    coordenadas = mensagem_recebida.strip('"').split(":")

    for i in range(0, len(coordenadas), 2):
        dict_coordenadas[coordenadas[i]].append(coordenadas[i+1])


    return dict_coordenadas

async def server(websocket, path):
    print("\nUm cliente acabou de se conectar")
    try:
        async for mensagem in websocket:
            mensagem_recebida = mensagem.decode("UTF-8")            
            print(f"\nMensagem recebida do cliente: {mensagem_recebida}")

            deslocamento_garra = armazena_coordenadas(mensagem_recebida, dict_deslocamento)
            print(f"\nDeslocamento da garra: {deslocamento_garra}")


            await websocket.send(mensagem_recebida)
            print(f"\nMensagem enviada para o cliente: {mensagem_recebida}")

    except websockets.exceptions.ConnectionClosed as e:
        print("\nUm cliente acabou de se desconectar")

PORTA_SERVIDOR = 5000

start_server = websockets.serve(server, "localhost", 5000)

asyncio.get_event_loop().run_until_complete(start_server)
print(f"\nServidor iniciado na porta {PORTA_SERVIDOR}")

asyncio.get_event_loop().run_forever()