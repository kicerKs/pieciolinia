extends "res://addons/gut/test.gd"

var test_root: Node = null

func _cleanup(mainScene):
	if mainScene and mainScene.is_inside_tree():
		mainScene.queue_free()
		
func test_volume_slider():
	var mainScene = load("res://scenes/main/main.tscn").instantiate()
	await wait_until(func ():
		get_parent().get_parent().add_child(mainScene)
		return mainScene.is_inside_tree()
	, 5)
	mainScene.name = "Main"
	var slider = get_node("/root/Main/GUI/DataTransfer/Control/MarginContainer/HBoxContainer/HBoxVolume/VolumeSlider")
	
	assert_not_null(slider != null, "VolumeSlider not found!")
	slider.value = 60
	assert_eq(slider.value, 60, "Value of slider is wrong!")
	print("Everything is ok")
	_cleanup(mainScene)
	
func test_rate_slider():
	var mainScene = load("res://scenes/main/main.tscn").instantiate()
	await wait_until(func ():
		get_parent().get_parent().add_child(mainScene)
		return mainScene.is_inside_tree()
	, 5)
	mainScene.name = "Main"
	var slider = get_node("/root/Main/GUI/DataTransfer/Control/MarginContainer/HBoxContainer/HBoxContainer/RateSlider")
	
	assert_not_null(slider != null, "RateSlider not found!")
	slider.value = 60
	assert_eq(slider.value, 60, "Value of slider is wrong!")
	print("Everything is ok")
	_cleanup(mainScene)
