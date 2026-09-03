extends Node2D

@export var dialogue: String = "res://Dialogues/sword_npc.dialogue"

@onready var action = $ActionArea

var configController
var dataNode

func _ready():
	dataNode = get_node("/root/MainRoom/DataController")
	configController = get_node("/root/MainRoom/ConfigController")
	action.actionated.connect(actioned)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func actioned():
	if dialogue != "":
		configController.canMovePlayer = false
		
		DialogueManager.show_example_dialogue_balloon(load(dialogue), "start")
	else:
		print("No dialogue set for this NPC.")

func _on_dialogue_ended(_resource: DialogueResource):
	configController.canMovePlayer = true