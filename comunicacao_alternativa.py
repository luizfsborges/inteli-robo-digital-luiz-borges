import asyncio
import websockets

async def server(websocket, path):
    print("\nUm cliente acabou de se conectar")
    try:
        async for mensagem in websocket:
            mensagem_recebida = mensagem.decode("UTF-8")            
            print(f"\nMensagem recebida do cliente: {mensagem_recebida}")
            await websocket.send(f"Você disse: {mensagem_recebida}")
            print(f"\nMensagem enviada para o cliente: {mensagem_recebida}")

    except websockets.exceptions.ConnectionClosed as e:
        print("\nUm cliente acabou de se desconectar")

PORTA_SERVIDOR = 5000

start_server = websockets.serve(server, "localhost", 5000)

asyncio.get_event_loop().run_until_complete(start_server)
print(f"\nServidor iniciado na porta {PORTA_SERVIDOR}")

asyncio.get_event_loop().run_forever()