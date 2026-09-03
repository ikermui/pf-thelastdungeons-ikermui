extends Control

@onready var button_jugar = $VBoxContainer/B_Jugar
@onready var button_salir = $VBoxContainer/B_Salir
@onready var button_cuenta = $VBoxContainer/B_Cuenta
@onready var button_puntuacion = $VBoxContainer/B_Puntuacion

var dataNode

func _ready():
	dataNode = get_node("/root/GameMenu/DataController")

func jugar():
	get_tree().change_scene_to_file("res://Scenes/Rooms/main_room.tscn")

func salir():
	get_tree().quit()

func cuenta():
	var menu = get_node("/root/GameMenu/MainMenu")
	var menu_cuenta
	if dataNode.email != null:
		menu_cuenta = get_node("/root/GameMenu/cuenta_datos")
	else:
		menu_cuenta = get_node("/root/GameMenu/cuenta_acceso")
	menu.visible = false
	menu_cuenta.visible = true

func verTabla():
	var menu = get_node("/root/GameMenu/MainMenu")
	var menu_points = get_node("/root/GameMenu/menu_points")
	menu.visible = false
	menu_points.visible = true
