extends Area2D

@export var newPosition: Vector2

func _on_body_entered(body: Node2D):
	if(body.name == "Player"):
		var mainNode = get_node("/root/MainRoom")
		var configController = get_node("/root/MainRoom/ConfigController")
		configController.enterRoomPosition = newPosition
		var player = mainNode.get_child(4).get_node("Player")
		player.position = newPosition
		configController.canMovePlayer = true
