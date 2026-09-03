extends Node2D

var canMovePlayer = false
var canFall = true
var canStaticMove = false
var posToMove
var direccionHitDamage = "DOWN"
var enterRoomPosition
var currentArea = "puerto"
var isPauseOpen = false

func movePlayerTo(pos):
    canStaticMove = true
    posToMove = pos