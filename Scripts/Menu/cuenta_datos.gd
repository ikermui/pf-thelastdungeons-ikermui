extends Control

@onready var button_volver = $VBoxContainer/B_Volver
@onready var button_close = $VBoxContainer/B_Cerrar
@onready var button_save = $VBoxContainer/B_Guardar
@onready var button_load = $VBoxContainer/B_Cargar
@onready var labelError = $MensajeError
@onready var labelExito = $MensajeExito

var userLabel
var dataNode

var headers = []
var step = 0
var temp_http  # Almacena temporalmente el HTTPRequest dinámico

func _ready():
	userLabel = get_node("/root/GameMenu/Account")
	dataNode = get_node("/root/GameMenu/DataController")

func volver():
	var menu = get_node("/root/GameMenu/MainMenu")
	var menu_cuenta = get_node("/root/GameMenu/cuenta_datos")
	menu.visible = true
	menu_cuenta.visible = false
	labelError.visible = false
	labelExito.visible = false

func cerrar():
	userLabel.text = "N/A"
	dataNode.email = null
	var menu = get_node("/root/GameMenu/cuenta_datos")
	var menu_cuenta = get_node("/root/GameMenu/cuenta_acceso")
	menu.visible = false
	menu_cuenta.visible = true
	labelError.visible = false
	labelExito.visible = false

func guardar():
	if dataNode.email != null:
		guardarBBDD()
	else:
		print("No se puede guardar")

func cargar():
	if dataNode.email != null:
		cargarBBDD()
	else:
		print("No se puede cargar")

func guardarBBDD():
	step = 1
	var http = HTTPRequest.new()
	add_child(http)
	temp_http = http  # Guardamos referencia para la segunda petición
	http.request_completed.connect(_on_request_completed)

	var url = "http://localhost:3000/user/updatePoints"
	var body = {
		"email": dataNode.email,
		"points": dataNode.points
	}
	var json_body = JSON.stringify(body)
	headers = ["Content-Type: application/json"]

	var err = http.request(url, headers, HTTPClient.METHOD_POST, json_body)
	if err != OK:
		mostrarError("Error al iniciar la petición POST")

func _on_request_completed(result, response_code, headers, body):
	if result != OK or response_code < 200 or response_code >= 300:
		mostrarError("Error en petición HTTP. Código: %s" % response_code)
		if is_instance_valid(temp_http):
			temp_http.queue_free()
		return

	if step == 1:
		step = 2
		var url = "http://localhost:3000/save/saveGame/" + dataNode.email
		var save_data = {
			"coins": dataNode.coins,
			"arrows": dataNode.arrows,
			"bombs": dataNode.bombs,
			"health": dataNode.health,
			"magic": dataNode.magic,
			"max_health": dataNode.max_health,
			"max_arrows": dataNode.max_arrows,
			"max_bombs": dataNode.max_bombs,
			"sword_level": dataNode.sword_level,
			"lake_rune": dataNode.lakeRune,
			"desert_rune": dataNode.desertRune,
			"dark_rune": dataNode.darkRune,
			"firstDialogueShow": dataNode.firstDialogueShow,
			"mapLocation": dataNode.mapLocation
		}
		var json_body = JSON.stringify(save_data)
		headers = ["Content-Type: application/json"]

		var err = temp_http.request(url, headers, HTTPClient.METHOD_PATCH, json_body)
		if err != OK:
			mostrarError("Error al iniciar la petición PATCH")
	elif step == 2:
		mostrarExito("Datos guardados correctamente")
		if is_instance_valid(temp_http):
			temp_http.queue_free()

func mostrarError(mensaje):
	labelError.text = mensaje
	labelError.visible = true
	labelExito.visible = false

func mostrarExito(mensaje):
	labelExito.text = mensaje
	labelExito.visible = true
	labelError.visible = false

func cargarBBDD():
	step = 1
	var http = HTTPRequest.new()
	add_child(http)
	temp_http = http
	http.request_completed.connect(_on_cargar_completed)

	var url = "http://localhost:3000/user/getOneEmail"
	var body = {
		"email": dataNode.email
	}
	var json_body = JSON.stringify(body)
	headers = ["Content-Type: application/json"]

	var err = http.request(url, headers, HTTPClient.METHOD_POST, json_body)
	if err != OK:
		mostrarError("Error al iniciar la petición de usuario")


func _on_cargar_completed(result, response_code, headers, body):
	if result != OK or response_code < 200 or response_code >= 300:
		mostrarError("Error al cargar datos. Código: %s" % response_code)
		if is_instance_valid(temp_http):
			temp_http.queue_free()
		return

	if step == 1:
		# Primer paso: cargar datos del usuario
		var text = body.get_string_from_utf8()
		var user_data = JSON.parse_string(text)

		if typeof(user_data) != TYPE_DICTIONARY:
			mostrarError("Respuesta inválida del usuario")
			temp_http.queue_free()
			return

		if user_data.has("points"):
			dataNode.points = user_data.points

		# Segundo paso: cargar datos del guardado
		step = 2
		var url = "http://localhost:3000/save/getSave/" + dataNode.email
		var err = temp_http.request(url, [], HTTPClient.METHOD_GET)
		if err != OK:
			mostrarError("Error al iniciar la petición de guardado")
	elif step == 2:
		# Segundo paso completado
		var text = body.get_string_from_utf8()
		var save_data = JSON.parse_string(text)

		if typeof(save_data) != TYPE_DICTIONARY:
			mostrarError("Respuesta inválida del guardado")
			temp_http.queue_free()
			return

		# Por cada campo, solo actualizamos si está presente
		dataNode.coins = save_data.get("coins", 0)
		dataNode.arrows = save_data.get("arrows", 0)
		dataNode.bombs = save_data.get("bombs", 0)
		dataNode.health = save_data.get("health", 2)
		dataNode.magic = save_data.get("magic", 1)
		dataNode.max_health = save_data.get("max_health", 9)
		dataNode.max_arrows = save_data.get("max_arrows", 40)
		dataNode.max_bombs = save_data.get("max_bombs", 20)
		dataNode.sword_level = save_data.get("sword_level", 1)
		dataNode.lakeRune = save_data.get("lake_rune", false)
		dataNode.desertRune = save_data.get("desert_rune", false)
		dataNode.darkRune = save_data.get("dark_rune", false)
		dataNode.firstDialogueShow = save_data.get("firstDialogueShow", true)
		dataNode.mapLocation = save_data.get("map_location", "house")
		dataNode.saveGame()
		mostrarExito("Datos cargados correctamente")
		if is_instance_valid(temp_http):
			temp_http.queue_free()
