extends Control

var dataNode

func _ready():
	self.visible = false
	DataNodeVariables.showDungeonKeys = false
	dataNode = get_node("/root/MainRoom/DataController")
	dataNode.gameOver.connect(showScreen)

func showScreen():
	self.visible = true
