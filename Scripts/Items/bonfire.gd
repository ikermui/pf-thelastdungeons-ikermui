extends Node2D

@onready var area = $ActionArea
@onready var flame = $Flame

var dataNode
var isFlameVisible = false
var canTurnOff = true

func _ready():
    area.actionated.connect(actioned)
    dataNode = get_node("/root/MainRoom/DataController")

func actioned():
    if dataNode.magic > 5:
        dataNode.magic = dataNode.magic - 5
        isFlameVisible = true
        flame.visible = true
        waitAndTurnOff()

func waitAndTurnOff():
    await get_tree().create_timer(10).timeout.connect(turnOffFlame)

func turnOffFlame():
    if canTurnOff:
        isFlameVisible = false
        flame.visible = false
