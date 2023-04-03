extends Node2D

var client = WebSocketClient.new()
var url = "ws://localhost:5000"

var zero_x = 695
var zero_y = 0.4
var zero_y_conversao = 650
var zero_z = 400

var limite_x_direita = 950
var limite_x_esquerda = 460

var limite_y_frente_real = 0.9
var limite_y_tras_real = 0.2

var limite_y_frente_conversao = 900
var limite_y_tras_conversao = 400


var limite_z_cima = 130
var limite_z_baixo = 400

func _ready():
	#client.connect("connection_closed", self, "connection_closed")
	#client.connect("connection_error", self, "connection_error")
	#client.connect("connection_established", self, "connection_established")
	client.connect("data_received", self, "mensagem_recebida")
	
	var erro = client.connect_to_url(url)
	
	if erro!= OK:
		set_process(false)
		print("Conexão mal sucedida")
		
	get_node("Label_X").get_child(0).set_text(str(zero_x))
	get_node("Label_Y").get_child(0).set_text(str(zero_y_conversao))
	get_node("Label_Z").get_child(0).set_text(str(zero_z))
	
	$Sprite_garra.scale.x = zero_y
	$Sprite_garra.scale.y = zero_y
	
	$Sprite_garra.position = Vector2(zero_x, zero_z)

func _process(delta):
	
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
	var mensagem_exibicao = str(mensagem_retorno.replace('"', '').replace(':', ': '))
	get_node("Label_feedback_coordenadas").set_text(mensagem_exibicao)
	
func mensagem_recebida():
	var mensagem = client.get_peer(1).get_packet().get_string_from_utf8()
	exibe_feedback(mensagem)
	
	var movimentos = mensagem.replace('"', '').split(":")
	var movimento_x = float(movimentos[1])
	var movimento_y = float(movimentos[3])
	var movimento_z = float(movimentos[5])

	var x_atual = $Sprite_garra.position.x
	var z_atual = $Sprite_garra.position.y

	mover_garra(x_atual, zero_y_conversao, z_atual, movimento_x, \
				movimento_y, movimento_z, $Sprite_garra)

func manda_mensagem(mensagem_enviada):
	client.get_peer(1).put_packet(JSON.print(mensagem_enviada).to_utf8())
	
var incremento_x = zero_x
func incrementar_x():
	if incremento_x <= limite_x_direita:
		incremento_x += 1
		get_node("Label_X").get_child(0).set_text(str(incremento_x))
	else:
		get_node("Label_X").get_child(0).set_text(str(limite_x_direita))
	
func decrementar_x():
	if incremento_x >= limite_x_esquerda:
		incremento_x -= 1
		get_node("Label_X").get_child(0).set_text(str(incremento_x))
	else:
		get_node("Label_X").get_child(0).set_text(str(limite_x_esquerda))
	
var incremento_y = zero_y_conversao
func incrementar_y():
	if incremento_y <= limite_y_frente_conversao:
		incremento_y += 1
		get_node("Label_Y").get_child(0).set_text(str(incremento_y))
	else:
		get_node("Label_Y").get_child(0).set_text(str(limite_y_frente_conversao))

func decrementar_y():
	if incremento_y >= limite_y_tras_conversao:
		incremento_y -= 1
		get_node("Label_Y").get_child(0).set_text(str(incremento_y))
	else:
		get_node("Label_Y").get_child(0).set_text(str(limite_y_tras_conversao))

var incremento_z = zero_z
func incrementar_z():
	if incremento_z <= limite_z_baixo:
		incremento_z += 1
		get_node("Label_Z").get_child(0).set_text(str(incremento_z))
	else:
		get_node("Label_Z").get_child(0).set_text(str(limite_z_baixo))
	
func decrementar_z():
	if incremento_z >= limite_z_cima:
		incremento_z -= 1
		get_node("Label_Z").get_child(0).set_text(str(incremento_z))
	else:
		get_node("Label_Z").get_child(0).set_text(str(limite_z_cima))
		
func _on_Button_enviar_pressed():
	var coordenada_x = get_node("Label_X").get_child(0).text
	var coordenada_y = get_node("Label_Y").get_child(0).text
	var coordenada_z = get_node("Label_Z").get_child(0).text
	var coordenadas_movimentacao = "X:" + coordenada_x + ":Y:" + \
	coordenada_y + ":Z:" + coordenada_z
	manda_mensagem(coordenadas_movimentacao)
	

func mapear(x, in_min, in_max, out_min, out_max):
		
	var valor_dimensionado = (x - in_min) * (out_max - out_min) \
								 / (in_max - in_min) + out_min
							
	return valor_dimensionado
	
func mover_garra(posicao_atual_x, posicao_atual_y, posicao_atual_z, \
				posicao_x, posicao_y, posicao_z, sprite_movimentacao):

	var delta_deslocamento_x = abs(posicao_x - posicao_atual_x)
	var delta_deslocamento_y = abs(posicao_y - posicao_atual_y)
	var delta_deslocamento_z = abs(posicao_z - posicao_atual_z)
	
	var lista_deltas = [delta_deslocamento_x, delta_deslocamento_y, delta_deslocamento_z]
	var delta_deslocamento = lista_deltas.max()
	
	if delta_deslocamento_x > 0:

		for i in range(delta_deslocamento_x):
			if i < delta_deslocamento_x:
				if posicao_x > posicao_atual_x:
					posicao_atual_x += 1
					sprite_movimentacao.position = Vector2(posicao_atual_x, posicao_atual_z)
					
				elif posicao_x < posicao_atual_x:
					posicao_atual_x-= 1
					sprite_movimentacao.position = Vector2(posicao_atual_x, posicao_atual_z)
					
			yield(get_tree().create_timer(0.01), "timeout")
			
			
	if delta_deslocamento_y > 0:
		
		var dimensao_y_convertida = mapear(posicao_y, limite_y_tras_conversao, 
									limite_y_frente_conversao, limite_y_tras_real, 
									limite_y_frente_real)

		sprite_movimentacao.scale.x = dimensao_y_convertida
		sprite_movimentacao.scale.y = dimensao_y_convertida
			
	if delta_deslocamento_z > 0:
			
		for i in range(delta_deslocamento_z):
			if posicao_z > posicao_atual_z:
				posicao_atual_z += 1
				sprite_movimentacao.position = Vector2(posicao_atual_x, posicao_atual_z)
			
			elif posicao_z < posicao_atual_z:
				posicao_atual_z-=1
				sprite_movimentacao.position = Vector2(posicao_atual_x, posicao_atual_z)
			yield(get_tree().create_timer(0.01), "timeout")
			
		
