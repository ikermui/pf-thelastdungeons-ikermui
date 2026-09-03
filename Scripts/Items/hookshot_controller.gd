extends Node2D

var chain = preload("res://Scenes/Items/AllyItems/ally_hookshot.tscn")

var chainx
var parentNode
var direccion = ""
var normalHook = false
var first = true
var last = false
var canStart = false
var chains = 0
var timer = 0
var rotInitial
var chainNodes = [] 


var configController

func _ready():
	configController = get_node("/root/MainRoom/ConfigController")
	parentNode = get_parent()

	match(direccion):
		"DOWN":
			rotInitial = 180
			self.position.x = self.position.x - 5
			self.position.y = self.position.y + 15
		"RIGHT":
			rotInitial = 90
			self.position.x = self.position.x + 10
			self.position.y = self.position.y + 2
		"UP":
			rotInitial = 0
			self.position.x = self.position.x + 5
			self.position.y = self.position.y - 8
		"LEFT":
			rotInitial = 270
			self.position.x = self.position.x - 10
			self.position.y = self.position.y + 2

	canStart = true

func _process(_delta):
	if canStart == true:
		chains = chains + 1
		match (direccion):
			"DOWN":
				configDrop()
				self.position.y = self.position.y + 8
				configLength()
				return
			"RIGHT":
				configDrop()
				self.position.x = self.position.x + 8
				configLength()
				return
			"UP":
				configDrop()
				self.position.y = self.position.y - 8
				configLength()
				return
			"LEFT":
				configDrop()
				self.position.x = self.position.x - 8
				configLength()
				return

func configDrop():
	chainx = chain.instantiate()
	chainx.rotation_degrees = rotInitial
	chainx.position = self.position

	if last == false:
		chainx.get_node("Sprite2D").frame = 0
	else:
		chainx.get_node("Sprite2D").frame = 1
	add_child(chainx)
	chainNodes.append(chainx)
		
func configLength():
	
	if normalHook == true:
		if chains == 3:
			last = true
		if chains == 4:
			canStart = false
			configController.canFall = false
			await get_tree().create_timer(timer).timeout
			configController.canMovePlayer = true
			configController.canFall = true
			queue_free()
	else:
		if chains == 7:
			last = true
		if chains == 8:
			canStart = false
			configController.canFall = false
			await get_tree().create_timer(timer).timeout
			configController.canMovePlayer = true
			configController.canFall = true
			queue_free()
		
func makeHookInvisible():
	for chainItem in chainNodes:
		if chainItem and is_instance_valid(chainItem):
			chainItem.visible = false
