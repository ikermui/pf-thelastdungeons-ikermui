extends Node2D

@onready var puzzle1 = $Puzzle1
@onready var puzzle2 = $Puzzle2
@onready var puzzle3 = $Puzzle3
@onready var puerta1 = $Puerta1
var completedPuzzle = false

func _ready():
    DataNodeVariables.showDungeonKeys = false
    DataNodeVariables.dungeonKeys = 0

func _physics_process(_delta):
    check_puzzle()

func check_puzzle():
    if !completedPuzzle:
        if puzzle1.isFlameVisible && puzzle2.isFlameVisible && puzzle3.isFlameVisible:
            puzzle1.canTurnOff = false
            puzzle2.canTurnOff = false
            puzzle3.canTurnOff = false
            completedPuzzle = true
            puerta1.queue_free()