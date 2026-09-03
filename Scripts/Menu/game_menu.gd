extends Control

@onready var button_jugar = $MainMenu/VBoxContainer/B_Jugar
@onready var button_salir = $MainMenu/VBoxContainer/B_Salir
@onready var button_cuenta = $MainMenu/VBoxContainer/B_Cuenta
@onready var button_puntuacion = $MainMenu/VBoxContainer/B_Puntuacion

func jugar():
	get_tree().change_scene_to_file("res://Scenes/Rooms/main_room.tscn")

func salir():
	get_tree().quit()

func verTabla():
	print("dsfasdf")
