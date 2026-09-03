extends Area2D

func _on_body_entered(body: Node2D):
    if body.name == "Player":
        collect_key()

func collect_key():
    DataNodeVariables.add_key()
    queue_free()
