extends Node2D

var note_size = 75
var accidental_size = 25
var space_between_notes = 10

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
#var is_pitched = {0: false, 1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false, 8: false, 9: false, 10: false, 11: false, 12: false, 13: false, 14: false, 15: false, 16: false, 17: false, 18: false, 19: false, 20: false, 21: false, 22: false, 23: false}
#var notes_positions = {0: 282, 2: 266, 4: 251, 5: 235, 7: 219, 9: 204, 11: 188, 12: 173, 14: 157, 16: 142, 17: 126, 19: 111, 21: 95, 23: 80}
#var pitched_notes_positions = {1: 282, 3: 266, 6: 235, 8: 219, 10: 204,  13: 173, 15: 157, 18: 126, 20: 111, 22: 95}
#var new_notes_positions = {0: 282, 1: 282, 2: 266, 3: 266, 4: 251, 5: 235, 6: 235, 7: 219, 8: 219, 9: 204, 10: 204, 11: 188, 12: 173, 13: 173, 14: 157, 15: 157, 16: 142, 17: 126, 18: 126, 19: 111, 20: 111, 21: 95, 22: 95, 23: 80}

var notes_position = {0: 282, 1: 266, 2: 251, 3: 235, 4: 219, 5: 204, 6: 188, 7: 173, 8: 157, 9: 142, 10: 126, 11: 111, 12: 95, 13: 80, 14: 64}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var measure_up = 4
	var measure_down = 4
	$MeasureDownLabel.text = str(measure_down)
	$MeasureUpLabel.text = str(measure_up)
	Global.stave_unit = note_size + accidental_size + space_between_notes

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_setup_stave():
	$MeasureDownLabel.text = str(Melody.meter_bottom)
	$MeasureUpLabel.text = str(Melody.meter_top)
	var length = 150
	#print("Setting up the stave")
	var i = 1
	for bar in Melody.tracks[0].get_bars():
		#print(bar)
		var j = 1
		for el in bar.get_elements():
			var new_element = stave_element_scene.instantiate()
			new_element.setup(i, el, Vector2i(length,notes_position[el.get_position()]))
			#print("I got: "+str(el))
			if el is Pause:
				#print("Making pause")
				length += note_size
			elif el is Note:
				#print("Making note")
				length += note_size
			elif el is Accidental:
				length += accidental_size
			add_child(new_element)
			length += space_between_notes
		length += 10
		var new_barline = ColorRect.new()
		new_barline.size = Vector2(1, 125)
		new_barline.color = Color(0,0,0,1)
		new_barline.position = Vector2(length, 235)
		new_barline.name = "Barline"+str(i)
		add_child(new_barline)
		length += 11
	
	$Background.size.x = length
	$"Line 1".size.x = length
	$"Line 2".size.x = length
	$"Line 3".size.x = length
	$"Line 4".size.x = length
	$"Line 5".size.x = length
