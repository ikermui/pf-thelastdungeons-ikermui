extends Button

func _button_pressed():
    print("Reintentando")
    get_tree().reload_current_scene()