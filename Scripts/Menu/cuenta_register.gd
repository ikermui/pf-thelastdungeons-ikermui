extends Control

@onready var emailText = $TextEmail
@onready var passwordText = $TextPassword
@onready var nameText = $TextNombre
@onready var button_volver = $B_Volver
@onready var button_entrar = $B_Entrar
@onready var labelError = $MensajeError
@onready var labelExito = $MensajeExito

func volver():
	var menu_acceso = get_node("/root/GameMenu/cuenta_acceso")
	var menu_register = get_node("/root/GameMenu/cuenta_register")
	menu_acceso.visible = true
	menu_register.visible = false
	labelError.visible = false
	labelExito.visible = false

func entrar():
	if emailText.text.strip_edges() == "" or passwordText.text.strip_edges() == "" or nameText.text.strip_edges() == "":
		mostrar_error("Rellena todos los campos")
		return
	
	if not validar_email(emailText.text.strip_edges()):
		mostrar_error("Formato de Email Invalido")
		return
	
	comprobar_email_existente()

func validar_email(email: String) -> bool:
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")
	return regex.search(email) != null

func comprobar_email_existente():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_email_check_completed)
	
	var url = "http://localhost:3000/user/getOneEmail"
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({"email": emailText.text.strip_edges()})
	
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		mostrar_error("Error de conexion con el servidor")
		http_request.queue_free()

func _on_email_check_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var http_request = get_children().filter(func(child): return child is HTTPRequest).back()
	if http_request:
		http_request.queue_free()
	
	if response_code == 200:
		mostrar_error("Ese email ya esta registrado")
	elif response_code == 404:
		registrar_usuario()
	else:
		mostrar_error("Error de conexion con el servidor")

func registrar_usuario():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_register_completed)
	
	var url = "http://localhost:3000/user/new"
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({
		"username": nameText.text.strip_edges(),
		"email": emailText.text.strip_edges(),
		"password": passwordText.text.strip_edges()
	})
	
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		mostrar_error("Error de conexion con el servidor")
		http_request.queue_free()

func _on_register_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var http_request = get_children().filter(func(child): return child is HTTPRequest).back()
	if http_request:
		http_request.queue_free()
	
	if response_code == 200 or response_code == 201:
		crear_guardado_vacio(emailText.text.strip_edges())
		labelError.visible = false
		labelExito.visible = true
		emailText.text = ""
		passwordText.text = ""
		nameText.text = ""

		print("Usuario registrado correctamente")
	else:
		mostrar_error("Error al insertar los datos")

func mostrar_error(mensaje: String):
	labelError.text = mensaje
	labelError.visible = true
	labelExito.visible = false
	print("Error: " + mensaje)

func crear_guardado_vacio(email: String):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(func(_r, _code, _h, _b): http_request.queue_free())
		
	var url = "http://localhost:3000/save/saveGame/" + email
	var headers = ["Content-Type: application/json"]
		
	var error = http_request.request(url, headers, HTTPClient.METHOD_PATCH)
	if error != OK:
		print("Error al crear guardado vacío")
		http_request.queue_free()
