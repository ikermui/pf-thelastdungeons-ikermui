extends Node2D

var configController
var dataNode
@onready var darkDoor = $DarkDoor

func _ready():
    configController = get_node("/root/MainRoom/ConfigController")
    dataNode = get_node("/root/MainRoom/DataController")
    configController.currentArea = "castillo"
    DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
    if DataNodeVariables.check_lake() && DataNodeVariables.check_desert() && DataNodeVariables.check_dark():
        darkDoor.queue_free()
    else:
        DialogueManager.show_example_dialogue_balloon(load("res://Dialogues/castillo_norunas.dialogue"), "start")
        configController.canMovePlayer = false
        

func _on_dialogue_ended(_resource: DialogueResource):
    configController.canMovePlayer = true