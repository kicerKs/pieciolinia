extends "res://addons/gut/test.gd"

var test_root: Node = null

func setup():
	test_root = Node.new()
	add_child(test_root)

	var midi_player = MidiPlayer.new()
	test_root.add_child(midi_player)

	var slider = HSlider.new()
	slider.name = "VolumeSlider"
	slider.min_value = 0
	slider.max_value = 100
	slider.value = 50
	test_root.add_child(slider)

	var upper_menu_instance = load("res://scenes/gui/upper_menu.gd").new()
	upper_menu_instance.player = midi_player
	test_root.add_child(upper_menu_instance)

func test_volume_slider():
	var slider = test_root.get_node("VolumeSlider")
	assert(slider != null, "VolumeSlider not found!")
	slider.value = 60
	assert(slider.value == 60, "Value of slider is wrong!")
	print("Everything is ok")
