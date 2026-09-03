extends CharacterBody2D

@export var speed: int = 85
var typeDamage = 1
@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var marker = $Marker2D
@onready var actionArea = $Marker2D/Area2D
@onready var hitboxDamage = $HitboxDamage
@onready var animationTree = $AnimationTree
@onready var bodyDetection = $BodyDetection
@onready var waterArea = $WaterDetection
@onready var holeArea = $HoleDetection

var moveDirection = Vector2.ZERO
var canDamage = true
var nearestActionable: ActionArea
var hitboxDamageScript: PlayerHitBoxDamage = PlayerHitBoxDamage.new()
var isSpecialAnim = false
var isMapOpen = false
var isInventoryOpen = false
var isPauseOpen = false

var dataNode

var configController


func _ready():
	animationTree.active = true
	dataNode = get_node("/root/MainRoom/DataController")
	configController = get_node("/root/MainRoom/ConfigController")
	configController.canMovePlayer = true

	waterArea.body_entered.connect(check_enter_water)
	waterArea.body_exited.connect(check_exit_water)
	
	holeArea.body_entered.connect(check_enter_hole)

func validateImput():
	moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed

func animateMovement():
	if velocity.length() == 0:
		if isSpecialAnim == false:
			animationTree["parameters/conditions/Idleling"] = true
			animationTree["parameters/conditions/Walking"] = false

	else:
		configController.direccionHitDamage = "DOWN"
		marker.rotation = deg_to_rad(0)
		hitboxDamage.rotation = deg_to_rad(0)
		if velocity.x < 0:
			configController.direccionHitDamage = "LEFT"
			marker.rotation = deg_to_rad(90)
			hitboxDamage.rotation = deg_to_rad(90)
		elif velocity.x > 0:
			configController.direccionHitDamage = "RIGHT"
			marker.rotation = deg_to_rad(-90)
			hitboxDamage.rotation = deg_to_rad(-90)
		elif velocity.y < 0:
			configController.direccionHitDamage = "UP"
			marker.rotation = deg_to_rad(180)
			hitboxDamage.rotation = deg_to_rad(180)	
		if isSpecialAnim == false:
			animationTree["parameters/Idle/blend_position"] = moveDirection
			animationTree["parameters/Walking/blend_position"] = moveDirection
			animationTree["parameters/Attack/blend_position"] = moveDirection
			animationTree["parameters/conditions/Idleling"] = false
			animationTree["parameters/conditions/Walking"] = true

func _physics_process(_delta):
	typeDamage = dataNode.idObject
	if configController.canStaticMove == true:
		velocity = position.direction_to(configController.posToMove) * (speed * 2)
		move_and_slide()

		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			if collision.get_collider() is StaticBody2D:
				configController.canStaticMove = false
				configController.canMovePlayer = true
		if position == configController.posToMove:
			configController.canStaticMove = false
			configController.canMovePlayer = true
		return

	if configController.canMovePlayer == true:
		if canDamage:
			detection_damage()
		validateImput()
		animateMovement()
		move_and_slide()	
		check_actionables()

func detection_damage():
	var areas: Array[Area2D] = bodyDetection.get_overlapping_areas()
	for area in areas:
		if canDamage:
			dataNode.health = dataNode.health - 1
			canDamage = false
			modulate = Color(1, 0.3, 0.3)
			get_tree().create_timer(3).timeout.connect(activeDamage)

func check_actionables() -> void:
	var areas: Array[Area2D] = actionArea.get_overlapping_areas()
	var shortDistance: float = INF
	var nextActionable: ActionArea = null
	for area in areas:
		var distance: float = area.global_position.distance_to(global_position)
		if distance < shortDistance:
			shortDistance = distance
			nextActionable = area

	if nextActionable != null:
		if nextActionable != nearestActionable or not is_instance_valid(nextActionable):
			nearestActionable = nextActionable
			print(nearestActionable)
	else:
		nearestActionable = null				

func check_enter_water(body) -> void:
	if body != null:
		print("entro al water")
		isSpecialAnim = true
		animationTree["parameters/conditions/Idleling"] = true
		animationTree["parameters/conditions/Walking"] = false
		animationTree["parameters/conditions/Attacking"] = false
		await get_tree().create_timer(0.1).timeout
		animationTree["parameters/conditions/Idleling"] = false
		animationTree["parameters/conditions/Swimming"] = true
	return

func check_exit_water(body) -> void:
	if body != null:
		print("sali del water")
		isSpecialAnim = false
		configController.canMovePlayer = false
		animationTree["parameters/conditions/Idleling"] = true
		animationTree["parameters/conditions/Walking"] = false
		animationTree["parameters/conditions/Attacking"] = false
		animationTree["parameters/conditions/Swimming"] = false
		await get_tree().create_timer(0.1).timeout
		animationTree["parameters/conditions/Idleling"] = true
		configController.canMovePlayer = true
	return

func check_enter_hole(body) -> void:
	if body != null:
		print("me cai")
		if configController.canFall == false:
			print("No se puede caer")
		else:
			isSpecialAnim = true
			configController.canMovePlayer = false
			animationTree["parameters/conditions/Idleling"] = true
			animationTree["parameters/conditions/Walking"] = false
			animationTree["parameters/conditions/Attacking"] = false
			await get_tree().create_timer(0.1).timeout
			animationTree["parameters/conditions/Idleling"] = false
			animationTree["parameters/conditions/Falling"] = true
			await get_tree().create_timer(0.4).timeout
			animationTree["parameters/conditions/Idleling"] = true
			animationTree["parameters/conditions/Falling"] = false
			position = configController.enterRoomPosition
			isSpecialAnim = false
			dataNode.health = dataNode.health - 1
			canDamage = false
			configController.canMovePlayer = true
			await get_tree().create_timer(1).timeout
			canDamage = true
	return

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("key_c"):
		if isMapOpen == false && configController.isPauseOpen == false:
			var invNode = get_node("/root/MainRoom/CanvasLayer/UIMain/InventorySystem")
			if invNode.activeInventory == false:
				configController.canMovePlayer = false
				invNode.activeInventory = true
				isInventoryOpen = true
				return
			else:
				configController.canMovePlayer = true
				invNode.activeInventory = false
				isInventoryOpen = false
				return

	if event.is_action_pressed("key_enter"):
		if isMapOpen == false && isInventoryOpen == false:
			var pauseNode = get_node("/root/MainRoom/CanvasLayer/UIMain/pause_game")
			pauseNode.activePause = true
			configController.isPauseOpen = true
			configController.canMovePlayer = false
			

	if event.is_action_pressed("key_m"):
		if isInventoryOpen == false && configController.isPauseOpen == false:
			var mapNode = get_node("/root/MainRoom/CanvasLayer/UIMain/WorldMap")
			if mapNode.activeMap == false:
				configController.canMovePlayer = false
				mapNode.activeMap = true
				isMapOpen = true
				return
			else:
				configController.canMovePlayer = true
				mapNode.activeMap = false
				isMapOpen = false
				return
	
	if configController.canMovePlayer == true:
		if event.is_action_pressed("key_x"):
				hitboxDamageScript.setup(self.get_parent(), Vector2(hitboxDamage.global_position), configController.direccionHitDamage, 2)
				hitboxDamageScript.createDamage()
				attack_animation()

		if event.is_action_pressed("ui_secondary_item"):
				configController.canMovePlayer = false
				hitboxDamageScript.setup(self.get_parent(), Vector2(hitboxDamage.global_position), configController.direccionHitDamage, typeDamage)
				hitboxDamageScript.createDamage()
				item_animation()
				configController.canMovePlayer = false
				await get_tree().create_timer(0.35).timeout
				configController.canMovePlayer = true

		if event.is_action_pressed("ui_accept") && nearestActionable != null:
			if is_instance_valid(nearestActionable):
				nearestActionable.emit_signal("actionated")

func attack_animation():
	animationTree["parameters/conditions/Attacking"] = true
	animationTree["parameters/conditions/Idleling"] = false
	animationTree["parameters/conditions/Walking"] = false
	configController.canMovePlayer = false
	await get_tree().create_timer(0.35).timeout
	animationTree["parameters/conditions/Attacking"] = false
	configController.canMovePlayer = true

func item_animation():
	match(configController.direccionHitDamage):
		"UP":
			sprite.frame = 52
		"RIGHT":
			sprite.frame = 61
		"DOWN":
			sprite.frame = 43
		"LEFT":
			sprite.frame = 70

func activeDamage():
	modulate = Color(1, 1, 1)
	canDamage = true
