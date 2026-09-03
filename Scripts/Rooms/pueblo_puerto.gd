extends Node2D

var configController
var dataNode

func _ready():
    configController = get_node("/root/MainRoom/ConfigController")
    dataNode = get_node("/root/MainRoom/DataController")
    configController.currentArea = "puerto"