extends TextureRect

func _on_exit_pressed():
	get_tree().quit()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		_on_exit_pressed()

func _ready():
	pass
