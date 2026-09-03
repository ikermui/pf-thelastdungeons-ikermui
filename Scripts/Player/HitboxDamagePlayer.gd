extends Node

class_name PlayerHitBoxDamage

var parentNode
var direccion: String
var posicion: Vector2
var idDamage: int
var instance

var arrow = preload("res://Scenes/Items/AllyItems/ally_arrow.tscn")
var slash = preload("res://Scenes/Items/AllyItems/ally_slash.tscn")
var hookshot = preload("res://Scenes/Items/hookshot_controller.tscn")
var lantern = preload("res://Scenes/Items/AllyItems/ally_lantern.tscn")
var bomb = preload("res://Scenes/Items/AllyItems/ally_bomb.tscn")


func setup(parent, body, direct, id):
	parentNode = parent
	posicion = body
	direccion = direct
	idDamage = id

func createDamage():
	match idDamage:
		1:
			instance = arrow.instantiate()
			instance.timer = 2
			instance.canMove = true
			instance.direccion = direccion
		2:
			instance = slash.instantiate()
			instance.timer = 0.35
			instance.canMove = false
			instance.direccion = direccion
		3:
			instance = hookshot.instantiate()
			instance.timer = 0.35
			instance.direccion = direccion
			#parentNode.get_node("Player").configController.canFall = true
		4:
			if parentNode.get_node("Player").has_node("Lantern") == false:
				instance = lantern.instantiate()
				parentNode.get_node("Player").add_child(instance)
			else:
				parentNode.get_node("Player").configController.canMovePlayer = true
				parentNode.get_node("Player").get_node("Lantern").queue_free()
			return
		5:
			instance = bomb.instantiate()
			parentNode.get_node("Player").configController.canMovePlayer = true


	
	instance.position = posicion
	parentNode.add_child(instance)    
