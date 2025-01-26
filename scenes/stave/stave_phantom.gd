extends TextureRect

var speed = 0.5
var dir: int = -1

var _texture_paths = {
	"WholeNote": "res://assets/notes/whole_note.png",
	"HalfNote": "res://assets/notes/half_note.png",
	"QuarterNote": "res://assets/notes/quarter_note.png",
	"EightNote": "res://assets/notes/eight_note.png",
	"SixteenthNote": "res://assets/notes/sixteenth_note.png",
	"ThirtysecondNote": "res://assets/notes/thirtysecond_note.png",
	"WholeRest": "res://assets/rests/whole_rest.png",
	"HalfRest": "res://assets/rests/half_rest.png",
	"QuarterRest": "res://assets/rests/quarter_rest.png",
	"EightRest": "res://assets/rests/eight_rest.png",
	"SixteenthRest": "res://assets/rests/sixteenth_rest.png",
	"ThirtysecondRest": "res://assets/rests/thirtysecond_rest.png",
	"Sharp": "res://assets/accidentals/sharp.png",
	"Natural": "res://assets/accidentals/natural.png",
	"Flat": "res://assets/accidentals/flat.png",
	"NOTE_WHOLE": "res://assets/notes/whole_note.png",
	"NOTE_HALF": "res://assets/notes/half_note.png",
	"NOTE_QUARTER": "res://assets/notes/quarter_note.png",
	"NOTE_EIGHT": "res://assets/notes/eight_note.png",
	"NOTE_SIXTEENTH": "res://assets/notes/sixteenth_note.png",
	"NOTE_THIRTYSECOND": "res://assets/notes/thirtysecond_note.png",
	"NOTE_WHOLE_REVERSE": "res://assets/notes/reverse_whole_note.png",
	"NOTE_HALF_REVERSE": "res://assets/notes/reverse_half_note.png",
	"NOTE_QUARTER_REVERSE": "res://assets/notes/reverse_quarter_note.png",
	"NOTE_EIGHT_REVERSE": "res://assets/notes/reverse_eight_note.png",
	"NOTE_SIXTEENTH_REVERSE": "res://assets/notes/reverse_sixteenth_note.png",
	"NOTE_THIRTYSECOND_REVERSE": "res://assets/notes/reverse_thirtysecond_note.png",
	"REST_WHOLE": "res://assets/rests/whole_rest.png",
	"REST_HALF": "res://assets/rests/half_rest.png",
	"REST_QUARTER": "res://assets/rests/quarter_rest.png",
	"REST_EIGHT": "res://assets/rests/eight_rest.png",
	"REST_SIXTEENTH": "res://assets/rests/sixteenth_rest.png",
	"REST_THIRTYSECOND": "res://assets/rests/thirtysecond_rest.png",
	"ACCIDENTAL_SHARP": "res://assets/accidentals/sharp.png",
	"ACCIDENTAL_NATURAL": "res://assets/accidentals/natural.png",
	"ACCIDENTAL_FLAT": "res://assets/accidentals/flat.png",
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self_modulate.a -= delta * speed * dir
	if self_modulate.a < 0 or self_modulate.a > 1:
		self_modulate.a = clamp(self_modulate.a, 0, 1)
		dir = dir * -1
	pass

func set_texture_from_toolbox():
	self.texture = load(_texture_paths[Global.toolbox_element])

func set_texture_from_dnd():
	if Global.dnd_element is Pause:
		self.texture = load(_texture_paths["REST_"+Global.dnd_element.type_to_string(Global.dnd_element.get_type())])
	elif Global.dnd_element is Note:
		self.texture = load(_texture_paths["NOTE_"+Global.dnd_element.type_to_string(Global.dnd_element.get_type())])
	else:
		self.texture = load(_texture_paths["ACCIDENTAL_"+Global.dnd_element.type_to_string(Global.dnd_element.get_type())])
