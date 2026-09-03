extends Node2D

@onready var effectArea = $ExplosionArea
@onready var particula = $ParticulaExplosion
@onready var sprite = $Sprite2D

var dataNode
var canDestroy = false

func _ready():
    dataNode = get_node("/root/MainRoom/DataController")
    if dataNode.bombs >= 1:
        dataNode.bombs = dataNode.bombs - 1
        await get_tree().create_timer(2).timeout
        particula.get_node("Timer").start()
        particula.get_node("GPUParticles2D").emitting = true
        sprite.visible = false
        await get_tree().create_timer(0.1).timeout
        canDestroy = true
        await get_tree().create_timer(0.5).timeout
        canDestroy = false
    else:
        queue_free()

func _process(_delta):
    if canDestroy == true:
        var areas: Array[Area2D] = effectArea.get_overlapping_areas()
        for area in areas:
            area.get_parent().queue_free()