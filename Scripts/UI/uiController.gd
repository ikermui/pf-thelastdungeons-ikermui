extends Control

var dataNode

@onready var lbl_coins = $UIStats/Panel/Sprite2D/Label
@onready var lbl_bombs = $UIStats/Panel2/Sprite2D/Label
@onready var lbl_arrows = $UIStats/Panel3/Sprite2D/Label
@onready var lbl_points = $PointStats/Label
@onready var lbl_keys = $ui_keys/Label
@onready var uiKeys = $ui_keys
@onready var manaBar = $UIManaBar/TextureProgressBar
@onready var health = $UIHealth/TextureRect2
@onready var maxHealth = $UIHealth/TextureRect
@onready var actualObject = $UIActualObject/Object

func _ready():
	dataNode = get_node("/root/MainRoom/DataController")
	dataNode.dataChange.connect(updateData)
	updateData()

func updateData():
	handleActualObject()
	handleHealthContainer()
	handleMana()
	handleStats()    

func handleActualObject():
	actualObject.texture = dataNode.actualObject

func handleHealthContainer():
	health.size.x = (dataNode.health * 8)
	maxHealth.size.x = (dataNode.max_health * 8)

func handleMana():
	manaBar.value = dataNode.magic
	
	
	

func handleStats():
	lbl_coins.text = str(dataNode.coins).pad_zeros(3)
	lbl_bombs.text = str(dataNode.bombs).pad_zeros(2)
	lbl_arrows.text = str(dataNode.arrows).pad_zeros(2)
	lbl_points.text = str(dataNode.points).pad_zeros(7)
	lbl_keys.text = str(DataNodeVariables.get_keys())
	uiKeys.visible = DataNodeVariables.showDungeonKeys
