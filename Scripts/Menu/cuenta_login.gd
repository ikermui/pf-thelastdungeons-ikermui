extends Control

@onready var textEmail = $TextEmail
@onready var textPassword = $TextPassword
@onready var button_volver = $B_Volver
@onready var button_entrar = $B_Entrar
@onready var labelError = $MensajeError

var dataNode
var userLabel

func _ready():
	userLabel = get_node("/root/GameMenu/Account")
	dataNode = get_node("/root/GameMenu/DataController")

func volver():
	var menu_acceso = get_node("/root/GameMenu/cuenta_acceso")
	var menu_login = get_node("/root/GameMenu/cuenta_login")
	labelError.visible = false
	menu_acceso.visible = true
	menu_login.visible = false

func entrar():
	if textEmail.text.strip_edges() == "" or textPassword.text.strip_edges() == "":
		mostrar_error("Rellena todos los campos")
		return
	
	hacer_login()

func hacer_login():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_login_completed)
	
	var url = "http://localhost:3000/user/login"
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({
		"email": textEmail.text.strip_edges(),
		"password": textPassword.text.strip_edges()
	})
	
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		mostrar_error("Error de conexión con el servidor")
		http_request.queue_free()

func _on_login_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var http_request = get_children().filter(func(child): return child is HTTPRequest).back()
	if http_request:
		http_request.queue_free()
	
	if response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(body.get_string_from_utf8())
		if parse_result == OK:
			login_exitoso(json.data)
		else:
			mostrar_error("Error de conexión con el servidor")
	elif response_code == 404:
		mostrar_error("Correo o contraseña incorrectos")
	else:
		mostrar_error("Error de conexión con el servidor")

func login_exitoso(user_data):
	var menu = get_node("/root/GameMenu/cuenta_login")
	var menu_cuenta = get_node("/root/GameMenu/cuenta_datos")
	
	dataNode.email = textEmail.text.strip_edges()
	
	if user_data.has("username"):
		userLabel.text = user_data["username"]
	
	textEmail.text = ""
	textPassword.text = ""
	
	labelError.visible = false
	menu.visible = false
	menu_cuenta.visible = true
	
	print("Usuario logueado correctamente")

func mostrar_error(mensaje: String):
	labelError.text = mensaje
	labelError.visible = true
	print("Error: " + mensaje)
