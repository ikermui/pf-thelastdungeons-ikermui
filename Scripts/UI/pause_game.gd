extends Control

@onready var button_resume = $VBoxContainer/B_Resume
@onready var button_save = $VBoxContainer/B_Save
@onready var button_exit = $VBoxContainer/B_Exit

var configController
var dataNode
var activePause = false

func resume_game():
	activePause = false
	configController.canMovePlayer = true
	configController.isPauseOpen = false

func save_game():
	dataNode.saveGame()
	activePause = false
	configController.canMovePlayer = true
	configController.isPauseOpen = false

func exit():
	dataNode.saveGame()
	get_tree().change_scene_to_file("res://Scenes/Menu/game_menu.tscn")

func _ready():
	dataNode = get_node("/root/MainRoom/DataController")
	configController = get_node("/root/MainRoom/ConfigController")

func _process(_delta):
	self.visible = activePause