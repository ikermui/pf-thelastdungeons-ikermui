extends Node

@onready var highlight = $HighLight
@onready var description = $Label
@onready var selectionables = $Selectables
var selectChilds
var activeInventory = false
var index = 0
var dataNode

func _ready():
    selectChilds = selectionables.get_children()
    highlight.global_position.x = selectChilds[index].global_position.x
    highlight.global_position.y = selectChilds[index].global_position.y - 1
    dataNode = get_node("/root/MainRoom/DataController")
    dataNode.actualObject = selectChilds[index].texture
    description.text = selectChilds[index].description
    dataNode.idObject = 1

func _process(_delta):
    self.visible = activeInventory
    highlight.global_position.x = selectChilds[index].global_position.x
    highlight.global_position.y = selectChilds[index].global_position.y - 1
    dataNode = get_node("/root/MainRoom/DataController")
    dataNode.actualObject = selectChilds[index].texture
    description.text = selectChilds[index].description
    dataNode.idObject = selectChilds[index].idItem

func _unhandled_input(event: InputEvent) -> void:
    if activeInventory == true:
        if event.is_action_pressed("ui_left"):
            prevItem()
            return
        if event.is_action_pressed("ui_right"):
            nextItem()
            return
        # if event.is_action_pressed("ui_left"):
        #     prevItem()
        #     return
        # if event.is_action_pressed("ui_left"):
        #     prevItem()
        #     return

func nextItem():
    if (selectChilds.size() - 1) != index:
        index += 1
    else:
        index = 0

func prevItem():
    if index != 0:
        index -= 1
    else:
        index = (selectChilds.size() - 1)
