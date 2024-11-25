extends Node2D

var note_size = 75
var accidental_size = 25
var stave_length = 150
@export var space_between_notes = 10
@export var stave_element_scene: PackedScene

# Positions y
# Model = Coords
# 0, 1 = 282
# 2, 3 = 266
# 4 = 251
# 5, 6 = 235
# 7, 8 = 219
# 9, 10 = 204
# 11 = 188
# 12, 13 = 173
# 14, 15 = 157
# 16 = 142
# 17, 18 = 126
# 19, 20 = 111
# 21, 22 = 95
# 23 = 80

var notes_position = {0: 282, 1: 266, 2: 251, 3: 235, 4: 219, 5: 204, 6: 188, 7: 173, 8: 157, 9: 142, 10: 126, 11: 111, 12: 95, 13: 80, 14: 64}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var measure_up = 4
	var measure_down = 4
	$MeasureDownLabel.text = str(measure_down)
	$MeasureUpLabel.text = str(measure_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup_stave():
	$MeasureDownLabel.text = str(Melody.meter_bottom)
	$MeasureUpLabel.text = str(Melody.meter_top)
	stave_length = 150
	var i = 1
	for bar in Melody.tracks[0].get_bars():
		var j = 1
		for el in bar.get_elements():
			var new_element = stave_element_scene.instantiate()
			new_element.setup(i, el, Vector2i(stave_length,notes_position[el.get_position()]))
			if el is Note:
				stave_length += note_size
			elif el is Accidental:
				stave_length += accidental_size
			add_child(new_element)
			stave_length += space_between_notes
		stave_length += 10
		var new_barline = ColorRect.new()
		new_barline.size = Vector2(1, 125)
		new_barline.color = Color(0,0,0,1)
		new_barline.position = Vector2(stave_length, 235)
		new_barline.name = "Barline"+str(i)
		add_child(new_barline)
		stave_length += 11
	
	$Background.size.x = stave_length
	$"Line 1".size.x = stave_length
	$"Line 2".size.x = stave_length
	$"Line 3".size.x = stave_length
	$"Line 4".size.x = stave_length
	$"Line 5".size.x = stave_length
	Global.set_stave_length(stave_length)
