extends CharacterBody2D

@export var speed: int = 180
@onready var sprite = $Sprite2D

var direccion
var moveDirection
var timer
var canMove
var oneTime = true

var dataNode
var configController

func _ready():
    get_tree().create_timer(timer).timeout.connect(expireTime)
    dataNode = get_node("/root/MainRoom/DataController")
    configController = get_node("/root/MainRoom/ConfigController")
    configController.canMovePlayer = true

func _process(_delta):
    if dataNode.arrows >= 1:
        sprite.visible = true
        match direccion:
            "DOWN": 
                rotation = deg_to_rad(0)
                moveDirection = Vector2.DOWN
                if oneTime == true:
                    oneTime = false
                    dataNode.arrows = dataNode.arrows - 1
                    position.y = position.y + 10
            "UP":
                rotation = deg_to_rad(180)
                moveDirection = Vector2.UP
                if oneTime == true:
                    oneTime = false
                    dataNode.arrows = dataNode.arrows - 1
                    position.y = position.y - 10
            "RIGHT":
                rotation = deg_to_rad(270)
                moveDirection = Vector2.RIGHT
                if oneTime == true:
                    oneTime = false
                    dataNode.arrows = dataNode.arrows - 1
                    position.x = position.x + 10
            "LEFT":
                rotation = deg_to_rad(90)
                moveDirection = Vector2.LEFT
                if oneTime == true:
                    oneTime = false
                    dataNode.arrows = dataNode.arrows - 1
                    position.x = position.x - 10
        if canMove == true:            
            velocity = moveDirection * speed
            move_and_slide()
    else:
        expireTime()

func expireTime():
    queue_free()