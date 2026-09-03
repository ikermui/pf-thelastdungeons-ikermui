
extends Control

@onready var firstLabel = $VScrollBar/Label
@onready var secondLabel = $VScrollBar/Label2
@onready var thirdLabel = $VScrollBar/Label3
@onready var fourthLabel = $VScrollBar/Label4
@onready var fifthLabel = $VScrollBar/Label5

var http_request: HTTPRequest
var labels_array: Array

func _ready():
	# Crear el array con los labels para facilitar el manejo
	labels_array = [firstLabel, secondLabel, thirdLabel, fourthLabel, fifthLabel]
	
	# Crear el nodo HTTPRequest
	http_request = HTTPRequest.new()
	add_child(http_request)
	
	# Conectar la señal de respuesta
	http_request.request_completed.connect(_on_request_completed)
	
	# Realizar la petición
	make_request()

func make_request():
	var url = "http://localhost:3000/user/getAll"
	var error = http_request.request(url)
	
	if error != OK:
		show_error("Error al realizar la petición HTTP")

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	# Verificar si hay errores en la respuesta
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		show_error("Error en la petición: código " + str(response_code))
		return
	
	# Convertir la respuesta a string
	var response_text = body.get_string_from_utf8()
	
	# Parsear el JSON
	var json = JSON.new()
	var parse_result = json.parse(response_text)
	
	if parse_result != OK:
		show_error("Error al parsear la respuesta JSON")
		return
	
	var data = json.data
	
	# Verificar que sea un array
	if not data is Array:
		show_error("Formato de respuesta incorrecto")
		return
	
	# Mostrar los datos en los labels
	display_leaderboard(data)

func display_leaderboard(users: Array):
	# Primero, limpiar todos los labels con formato por defecto
	for i in range(labels_array.size()):
		labels_array[i].text = str(i + 1) + " - "
	
	# Llenar los labels con los datos disponibles
	for i in range(min(users.size(), labels_array.size())):
		var user = users[i]
		var username = user.get("username", "Unknown")
		var points = user.get("points", 0)
		
		labels_array[i].text = str(i + 1) + " - " + username + " - " + str(points) + " pts"

func show_error(error_message: String):
	# Ocultar todos los labels originales
	for label in labels_array:
		label.visible = false
	
	# Crear un label de error
	var error_label = Label.new()
	error_label.text = "Error: " + error_message
	error_label.add_theme_color_override("font_color", Color.RED)
	
	# Añadir el label de error al contenedor
	$VScrollBar.add_child(error_label)

func volver():
	var menu = get_node("/root/GameMenu/MainMenu")
	var menu_points = get_node("/root/GameMenu/menu_points")
	menu.visible = true
	menu_points.visible = false
