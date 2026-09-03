extends Area2D

@export var nextScene: String
@export var initialPosition: Vector2


func _on_body_entered(body: Node2D):
	if(body.name == "Player"):
		var mainNode = get_node("/root/MainRoom")
		var configController = get_node("/root/MainRoom/ConfigController")
		configController.enterRoomPosition = initialPosition
		var nodeDelete = mainNode.get_child(4)
		nodeDelete.queue_free();
		var next = load(nextScene)
		var instance = next.instantiate()
		instance.get_node("Player").position = configController.enterRoomPosition
		mainNode.call_deferred("add_child", instance)
