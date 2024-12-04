extends Node2D

@onready var popup = $PopUpExit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_button_button_down() -> void:
	popup.show()
	#get_tree().quit()


#func _on_exit_approved_button_down() -> void:
	#get_tree().quit()


#func _on_window_close_requested() -> void:
	#popup.hide()


#func _on_pop_up_exit_close_requested() -> void:
	#popup.hide()
	#pass # Replace with function body.


func _on_pop_up_exit_close_requested() -> void:
	popup.hide()


func _on_button_approved_button_down() -> void:
	get_tree().quit()

func _on_button_discard_button_down() -> void:
	popup.hide()
