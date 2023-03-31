extends Node2D

var client = WebSocketClient.new()
var url = "ws://localhost:5000"

func _ready():
	#client.connect("connection_closed", self, "connection_closed")
	#client.connect("connection_error", self, "connection_error")
	#client.connect("connection_established", self, "connection_established")
	client.connect("data_received", self, "mensagem_recebida")
	
	var erro = client.connect_to_url(url)
	
	if erro!= OK:
		set_process(false)
		print("Conexão mal sucedida")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	#mostra_coordenada_x(678)
	client.poll()
	
	if $Button_frente.pressed:
		decrementar_y()
	elif $Button_tras.pressed:
		incrementar_y()
	elif $Button_direita.pressed:
		incrementar_x()
	elif $Button_esquerda.pressed:
		decrementar_x()
	elif $Button_levantar.pressed:
		incrementar_z()
	elif $Button_abaixar.pressed:
		decrementar_z()
	
func exibe_feedback(mensagem_retorno):
	get_node("Label_feedback_coordenadas").set_text(str(mensagem_retorno))
	
func mensagem_recebida():
	var mensagem = client.get_peer(1).get_packet().get_string_from_utf8()
	exibe_feedback(mensagem)
	
	var movimentos = mensagem.replace('"', '').split(":")
	var movimento_x = float(movimentos[1])
	var movimento_y = float(movimentos[3])
	var movimento_z = float(movimentos[5])
	
	$Sprite_garra.move_local_x(movimento_x)
	$Sprite_garra.move_local_y(movimento_y)
	$Sprite_garra.scale.x = movimento_z*0.01
	$Sprite_garra.scale.y = movimento_z*0.01
	

func manda_mensagem(mensagem_enviada):
	client.get_peer(1).put_packet(JSON.print(mensagem_enviada).to_utf8())
	

var incremento_x = 0
func incrementar_x():
	incremento_x += 1
	get_node("Label_X").get_child(0).set_text(str(incremento_x))
	
func decrementar_x():
	incremento_x -= 1
	get_node("Label_X").get_child(0).set_text(str(incremento_x))
	
var incremento_y = 0
func incrementar_y():
	incremento_y += 1
	get_node("Label_Y").get_child(0).set_text(str(incremento_y))
	
func decrementar_y():
	incremento_y -= 1
	get_node("Label_Y").get_child(0).set_text(str(incremento_y))
	
var incremento_z = 0
func incrementar_z():
	incremento_z += 1
	get_node("Label_Z").get_child(0).set_text(str(incremento_z))
	
func decrementar_z():
	incremento_z -= 1
	get_node("Label_Z").get_child(0).set_text(str(incremento_z))
	
func _on_Button_enviar_pressed():
	var coordenada_x = get_node("Label_X").get_child(0).text
	var coordenada_y = get_node("Label_Y").get_child(0).text
	var coordenada_z = get_node("Label_Z").get_child(0).text
	var coordenadas_movimentacao = "X:" + coordenada_x + ":Y:" + \
	coordenada_y + ":Z:" + coordenada_z
	manda_mensagem(coordenadas_movimentacao)
