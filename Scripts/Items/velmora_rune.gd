extends Area2D

var dataNode
var configController
var runeCollected

func _ready():
    runeCollected = false
    configController = get_node("/root/MainRoom/ConfigController")
    dataNode = get_node("/root/MainRoom/DataController")
    DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_body_entered(body: Node2D):
    if body.name == "Player":
        collect_rune()

func collect_rune():
    dataNode.points += 10000
    DialogueManager.show_example_dialogue_balloon(load("res://Dialogues/fin_juego.dialogue"), "start")
    configController.canMovePlayer = false
    runeCollected = true
    dataNode.saveGame()
    

func _on_dialogue_ended(_resource: DialogueResource):
    configController.canMovePlayer = true
    if runeCollected == true:
        queue_free()