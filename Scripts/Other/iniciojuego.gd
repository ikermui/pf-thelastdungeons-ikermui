extends Node2D

var configController
var dataNode

func _ready():
        configController = get_node("/root/MainRoom/ConfigController")
        dataNode = get_node("/root/MainRoom/DataController")
        if dataNode.firstDialogueShow == true:
                configController.canMovePlayer = false
                DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
                DialogueManager.show_example_dialogue_balloon(load("res://Dialogues/dialogueInicio.dialogue"), "start")

func _on_dialogue_ended(_resource: DialogueResource):
        configController.canMovePlayer = true
        dataNode.firstDialogueShow = false