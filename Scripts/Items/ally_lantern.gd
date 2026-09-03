extends Node2D

@onready var sprite = $Sprite2D

var dataNode
var configController
var canMinus = true

func _ready():
	dataNode = get_node("/root/MainRoom/DataController")
	configController = get_node("/root/MainRoom/ConfigController")
	configController.canMovePlayer = true
	position.y = -6

func _process(_delta):
	validateDirection()
	if canMinus == true:
		if dataNode.magic == 1:
			queue_free()
		minusMagic()

func minusMagic():
	canMinus = false
	await get_tree().create_timer(2).timeout
	dataNode.magic = dataNode.magic - 1
	canMinus = true

func validateDirection():
	match configController.direccionHitDamage:
		"DOWN":
			sprite.frame = 0
		"UP":
			sprite.frame = 1
		"LEFT":
			sprite.frame = 3
		"RIGHT":
			sprite.frame = 2
