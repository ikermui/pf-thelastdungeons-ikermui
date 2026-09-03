extends CharacterBody2D

@onready var actionArea = $Area2D
@onready var detectionArea = $DetectionArea
@onready var outArea = $OutArea

@export var enemyHealth: int = 3

var dataNode

var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN, Vector2.ZERO]
var moveDirection
var speed: int = 50

var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_strength: float = 250.0
var knockback_friction: float = 5.0

var rng = RandomNumberGenerator.new()
var randomNumber = 0

var playerLocated = false
var player

func _ready():
	dataNode = get_node("/root/MainRoom/DataController")

func _physics_process(delta):
	check_death()
	check_actionables()
	check_Near_Player()
	check_outside()
	
	if knockback_velocity.length() > 0:
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_friction * knockback_strength * delta)
	else:
		random_Move()
	
	move_and_slide()
	randomNumber -= 1

func check_death():
	if enemyHealth <= 0:
		generate_item()
		dataNode.points = dataNode.points + 100
		queue_free()

func check_outside():
	if playerLocated == true:
		var playerOut = true
		var areas: Array[Area2D] = outArea.get_overlapping_areas()
		for area in areas:
			if area.get_parent().name == "Player":
				playerOut = false
		if playerOut == true:
			playerLocated = false

func check_actionables() -> void:
	var areas: Array[Area2D] = actionArea.get_overlapping_areas()
	for area in areas:
		var damage = 1
		if area.name == "Sword":
			damage = 1 * dataNode.sword_level
		if area.name == "HookArea":
			damage = 0
		print(area.name)
		enemyHealth -= damage
		
		apply_knockback()
		
		area.get_parent().queue_free()

func apply_knockback():
	var knockback_direction: Vector2
	
	if playerLocated and player:
		knockback_direction = (position - player.position).normalized()
	knockback_velocity = knockback_direction * knockback_strength

func check_Near_Player():
	if playerLocated == false:
		var areas: Array[Area2D] = detectionArea.get_overlapping_areas()
		for area in areas:
			player = area.get_parent()
			playerLocated = true

func random_Move():
	if randomNumber == 0:
		randomNumber = rng.randi_range(10, 20)
		moveDirection = directions.pick_random()

	if playerLocated == false:
		velocity = moveDirection * speed
	else:
		velocity = position.direction_to(player.position) * speed

func generate_item():
	var itemType = randi_range(1, 5)
	var minimo = 1
	var maximo = 3
	if itemType == 5 || itemType == 2:
		maximo = 2
	if itemType == 2:
		minimo = 5
		maximo = 10
	var itemValue = randi_range(minimo, maximo)
	var recolectableItem = preload("res://Scenes/Items/recolectable_item.tscn").instantiate()
	recolectableItem.iditem = itemType
	recolectableItem.value = itemValue
	recolectableItem.z_index = 4
	var unique_id = randi_range(1, 999999)
	recolectableItem.name = "RecolectableEnemy" + str(unique_id)
	get_parent().add_child(recolectableItem)
	recolectableItem.global_position = global_position
	print(recolectableItem.name)
