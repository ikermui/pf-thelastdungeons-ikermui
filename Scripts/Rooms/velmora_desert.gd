extends Node2D

var configController
var dataNode

func _ready():
    DataNodeVariables.showDungeonKeys = false
    DataNodeVariables.dungeonKeys = 0
    configController = get_node("/root/MainRoom/ConfigController")
    dataNode = get_node("/root/MainRoom/DataController")
    configController.currentArea = "desierto"