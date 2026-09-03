extends Node2D

@onready var area2D = $HookArea

var canValidate = false

var configController

func _ready():
    
    configController = get_node("/root/MainRoom/ConfigController")

func _process(_delta):
    if canValidate == false:
        validateAreas()

func validateAreas():
    var areas: Array[Area2D] = area2D.get_overlapping_areas()
    for area in areas:
        canValidate = true
        
        if area.name.contains("RecolectableItem") || area.name.contains("RecolectableEnemy"):
            configController.canFall = true
            area.collectItem()
            get_parent().queue_free()
            configController.canFall = true
            configController.canMovePlayer = true
        elif area.name == "NearableItem":
            get_parent().makeHookInvisible()
            configController.movePlayerTo(area.global_position)
            await get_tree().create_timer(0.5).timeout
            get_parent().queue_free()
        return