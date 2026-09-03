extends Area2D

@export var iditem: int = 0
@export var value: int = 0

var dataNode
var configController

func _ready():
	configController = get_node("/root/MainRoom/ConfigController")
	dataNode = get_node("/root/MainRoom/DataController")
	match iditem:
		1:
			$Sprite2D.texture = preload("res://Resources/Items/Coin.png")
		2:
			$Sprite2D.texture = preload("res://Resources/Items/Magic.png")
		3:
			$Sprite2D.texture = preload("res://Resources/Items/Bomb.png")
		4:
			$Sprite2D.texture = preload("res://Resources/Items/Arrow.png")
		5:
			$Sprite2D.texture = preload("res://Resources/Items/Heart.png")

func _on_body_entered(body:Node2D):
	
	if(body.name == "Player"):
		collectItem()

func collectItem():
	match iditem:
			1:
				dataNode.coins = dataNode.coins + value
				dataNode.points = dataNode.points + (value * 3)
			2:
				dataNode.magic = dataNode.magic + value
				dataNode.points = dataNode.points + (value * 2)
			3:
				dataNode.bombs = dataNode.bombs + value
				dataNode.points = dataNode.points + (value * 10)
			4:
				dataNode.arrows = dataNode.arrows + value
				dataNode.points = dataNode.points + (value * 10)
			5:
				dataNode.health = dataNode.health + value
				dataNode.points = dataNode.points + (value * 10)
	configController.canFall = true
	queue_free()
