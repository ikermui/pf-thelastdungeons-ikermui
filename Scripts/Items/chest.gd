extends Node2D

#@export var objects: Array[PackedScene]
@export var item_type: int = 1
@export var item_value: int = 1

@onready var area = $ActionArea
@onready var sprite = $Sprite2D
@onready var item = $Item
@onready var quantityLabel = $Quantity

var opened = false;
var dataNode

func _ready():
	dataNode = get_node("/root/MainRoom/DataController")
	area.actionated.connect(actioned)
	match item_type:
		1:
			item.texture = preload("res://Resources/Items/Coin.png")
		2:
			item.texture = preload("res://Resources/Items/Magic.png")
		3:
			item.texture = preload("res://Resources/Items/Bomb.png")
		4:
			item.texture = preload("res://Resources/Items/Arrow.png")
		5:
			item.texture = preload("res://Resources/Items/Heart.png")

func actioned():
	if opened == false:
		var recolectable = preload("res://Scenes/Items/recolectable_item.tscn").instantiate()
		recolectable.iditem = item_type
		recolectable.value = item_value
		get_parent().add_child(recolectable)
		recolectable.collectItem()
		opened = true
		dataNode.points = dataNode.points + 50
		sprite.texture = load("res://Resources/Items/World/opened_chest.png")
		item.visible = true
		quantityLabel.text = "x" + str(item_value)
		quantityLabel.visible = true
		get_tree().create_timer(0.75).timeout.connect(invisible_again)
			
		# for obj in objects:
		# 	print(obj.instantiate())
		# 	opened = true


func invisible_again():
		quantityLabel.visible = false
		item.visible = false