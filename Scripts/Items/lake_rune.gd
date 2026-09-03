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
    if !dataNode.lakeRune:
        dataNode.points += 2000
        dataNode.health = dataNode.max_health
        dataNode.magic = dataNode.max_magic
        
    dataNode.lakeRune = true
    DialogueManager.show_example_dialogue_balloon(load("res://Dialogues/lake_rune.dialogue"), "start")
    configController.canMovePlayer = false
    runeCollected = true
    dataNode.saveGame()
    

func _on_dialogue_ended(_resource: DialogueResource):
    configController.canMovePlayer = true
    if runeCollected == true:
        queue_free()