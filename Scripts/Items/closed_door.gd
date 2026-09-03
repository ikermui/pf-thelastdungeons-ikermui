extends Node2D

@onready var area = $ActionArea
var configController

func _ready():
    configController = get_node("/root/MainRoom/ConfigController")
    area.actionated.connect(actioned)
    DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func actioned():
    if DataNodeVariables.get_keys() > 0:
        DataNodeVariables.remove_key()
        queue_free()
    else:
        configController.canMovePlayer = false
        DialogueManager.show_example_dialogue_balloon(load("res://Dialogues/nollave.dialogue"), "start")

func _on_dialogue_ended(_resource: DialogueResource):
    configController.canMovePlayer = true