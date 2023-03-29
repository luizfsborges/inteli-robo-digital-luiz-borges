extends Node2D

var client = WebSocketClient.new()
var url = "ws://localhost:5000"

func mostra_coordenada_x(coordenada_x):
	get_node("LineEditCoordenadaX").set_text(str(coordenada_x))

# Called when the node enters the scene tree for the first time.
func _ready():
	client.connect("Comunicação encerrada", self, "comunicação encerrada")
	client.connect("Erro de comunicação", self, "erro de comunicação")
	client.connect("Conexão estabelecida", self, "Conectado")
	client.connect("mensagem_recebida", self, "mensagem_recebida")
	
	
	var erro = client.connect_to_url(url)
	
	if erro!= OK:
		set_process(false)
		print("Conexão mal sucedida")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	#mostra_coordenada_x(678)
	client.poll()
	
func mensagem_recebida():
	var mensagem = client.get_peer(1).get_packet().get_string_from_utf8()
	mostra_coordenada_x(mensagem)

func manda_mensagem(mensagem_enviada):
	client.get_peer(1).put_packet(JSON.print(mensagem_enviada).to_utf8())
	
func _on_ButtonEnvio_pressed():
	manda_mensagem(get_node("LineEditComandoX").text)
	mensagem_recebida()
