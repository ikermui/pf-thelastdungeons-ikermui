extends Control

var configController
var dataNode
var activeMap = false

@onready var locationSprite = $Location
@onready var map = $Sprite2D
@onready var lake = $Lake
@onready var desert = $Desert
@onready var dark = $Dark

func _ready():
    dataNode = get_node("/root/MainRoom/DataController")
    configController = get_node("/root/MainRoom/ConfigController")

func _process(_delta):
    self.visible = activeMap
    match (configController.currentArea):
        "puerto":
            locationSprite.global_position = Vector2(122, 113)
        "campo":
            locationSprite.global_position = Vector2(118, 67)
        "desierto":
            locationSprite.global_position = Vector2(54, 105)
        "terreno":
            locationSprite.global_position = Vector2(56, 50)
        "bosque":
            locationSprite.global_position = Vector2(176, 87)
        "pueblo":
            locationSprite.global_position = Vector2(171, 47)
        "castillo":
            locationSprite.global_position = Vector2(122, 37)
        _:
            locationSprite.global_position = Vector2(122, 113)
    if DataNodeVariables.check_lake():
        lake.visible = false
    else:
        lake.visible = true
    if DataNodeVariables.check_desert():
        desert.visible = false
    else:
        desert.visible = true
    if DataNodeVariables.check_dark():
        dark.visible = false
    else:
        dark.visible = true