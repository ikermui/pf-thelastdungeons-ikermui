extends Node2D

@onready var dark_rune = $DarkRune
@onready var oscuridad = $CanvasModulate

@onready var puzzle1_1 = $Puzzle1_1
@onready var puzzle1_2 = $Puzzle1_2
@onready var puzzle1_3 = $Puzzle1_3
@onready var puzzle1_4 = $Puzzle1_4
@onready var puerta1 = $Puerta1
var completed1 = false

@onready var puzzle2_1 = $Puzzle2_1
@onready var puzzle2_2 = $Puzzle2_2
@onready var puzzle2_3 = $Puzzle2_3
@onready var puzzle2_4 = $Puzzle2_4
@onready var puerta2 = $Puerta2
var completed2 = false

@onready var puzzle3_1 = $Puzzle3_1
@onready var puzzle3_2 = $Puzzle3_2
@onready var puzzle3_3 = $Puzzle3_3
@onready var puzzle3_4 = $Puzzle3_4
@onready var puerta3 = $Puerta3
var completed3 = false

@onready var puzzle4_1 = $Puzzle4_1
@onready var puzzle4_2 = $Puzzle4_2
@onready var puzzle4_3 = $Puzzle4_3
@onready var puzzle4_4 = $Puzzle4_4
@onready var puerta4 = $Puerta4
var completed4 = false

@onready var alwaysVisible1 = $AlwaysVisible1
@onready var alwaysVisible2 = $AlwaysVisible2
@onready var alwaysVisible3 = $AlwaysVisible3
@onready var alwaysVisible4 = $AlwaysVisible4
@onready var alwaysVisible5 = $AlwaysVisible5
@onready var alwaysVisible6 = $AlwaysVisible6
@onready var flameVisible1 = $AlwaysVisible1/Flame
@onready var flameVisible2 = $AlwaysVisible2/Flame
@onready var flameVisible3 = $AlwaysVisible3/Flame
@onready var flameVisible4 = $AlwaysVisible4/Flame
@onready var flameVisible5 = $AlwaysVisible5/Flame
@onready var flameVisible6 = $AlwaysVisible6/Flame

func _ready():
    DataNodeVariables.showDungeonKeys = true
    DataNodeVariables.dungeonKeys = 0
    dark_rune.collected.connect(dungeon_completed)
    turnOnFire()

func _physics_process(_delta):
    check_puzzle1()
    check_puzzle2()
    check_puzzle3()
    check_puzzle4()

func turnOnFire():
    alwaysVisible1.canTurnOff = false
    alwaysVisible2.canTurnOff = false
    alwaysVisible3.canTurnOff = false
    alwaysVisible4.canTurnOff = false
    alwaysVisible5.canTurnOff = false
    alwaysVisible6.canTurnOff = false
    flameVisible1.visible = true
    flameVisible2.visible = true
    flameVisible3.visible = true
    flameVisible4.visible = true
    flameVisible5.visible = true
    flameVisible6.visible = true
    alwaysVisible1.isFlameVisible = true
    alwaysVisible2.isFlameVisible = true
    alwaysVisible3.isFlameVisible = true
    alwaysVisible4.isFlameVisible = true
    alwaysVisible5.isFlameVisible = true
    alwaysVisible6.isFlameVisible = true

func check_puzzle1():
    if !completed1:
        if puzzle1_1.isFlameVisible && puzzle1_2.isFlameVisible && puzzle1_3.isFlameVisible && puzzle1_4.isFlameVisible:
            puzzle1_1.canTurnOff = false
            puzzle1_2.canTurnOff = false
            puzzle1_3.canTurnOff = false
            puzzle1_4.canTurnOff = false
            completed1 = true
            puerta1.queue_free()

func check_puzzle2():
    if !completed2:
        if puzzle2_1.isFlameVisible && puzzle2_2.isFlameVisible && puzzle2_3.isFlameVisible && puzzle2_4.isFlameVisible:
            puzzle2_1.canTurnOff = false
            puzzle2_2.canTurnOff = false
            puzzle2_3.canTurnOff = false
            puzzle2_4.canTurnOff = false
            completed2 = true
            puerta2.queue_free()

func check_puzzle3():
    if !completed3:
        if puzzle3_1.isFlameVisible && puzzle3_2.isFlameVisible && puzzle3_3.isFlameVisible && puzzle3_4.isFlameVisible:
            puzzle3_1.canTurnOff = false
            puzzle3_2.canTurnOff = false
            puzzle3_3.canTurnOff = false
            puzzle3_4.canTurnOff = false
            completed3 = true
            puerta3.queue_free()

func check_puzzle4():
    if !completed4:
        if puzzle4_1.isFlameVisible && puzzle4_2.isFlameVisible && puzzle4_3.isFlameVisible && puzzle4_4.isFlameVisible:
            puzzle4_1.canTurnOff = false
            puzzle4_2.canTurnOff = false
            puzzle4_3.canTurnOff = false
            puzzle4_4.canTurnOff = false
            completed4 = true
            puerta4.queue_free()

func dungeon_completed():
    oscuridad.visible = false