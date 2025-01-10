extends Node2D

var barline = null
var staffDrawable: StaffDrawable

var _texture_paths = {
	"NOTE_WHOLE": "res://assets/notes/whole_note.png",
	"NOTE_HALF": "res://assets/notes/half_note.png",
	"NOTE_QUARTER": "res://assets/notes/quarter_note.png",
	"NOTE_EIGHT": "res://assets/notes/eight_note.png",
	"NOTE_SIXTEENTH": "res://assets/notes/sixteenth_note.png",
	"NOTE_WHOLE_REVERSE": "res://assets/notes/reverse_whole_note.png",
	"NOTE_HALF_REVERSE": "res://assets/notes/reverse_half_note.png",
	"NOTE_QUARTER_REVERSE": "res://assets/notes/reverse_quarter_note.png",
	"NOTE_EIGHT_REVERSE": "res://assets/notes/reverse_eight_note.png",
	"NOTE_SIXTEENTH_REVERSE": "res://assets/notes/reverse_sixteenth_note.png",
	"REST_WHOLE": "res://assets/rests/whole_rest.png",
	"REST_HALF": "res://assets/rests/half_rest.png",
	"REST_QUARTER": "res://assets/rests/quarter_rest.png",
	"REST_EIGHT": "res://assets/rests/eight_rest.png",
	"REST_SIXTEENTH": "res://assets/rests/sixteenth_rest.png",
	"ACCIDENTAL_SHARP": "res://assets/accidentals/sharp.png",
	"ACCIDENTAL_NATURAL": "res://assets/accidentals/natural.png",
	"ACCIDENTAL_FLAT": "res://assets/accidentals/flat.png",
	"PEDAL_ON": "res://assets/misc/pedal_on.png",
	"PEDAL_OFF": "res://assets/misc/pedal_off.png",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup(bar_number: int, el: StaffDrawable, pos: Vector2i):
	barline = bar_number
	staffDrawable = el
	self.position = pos
	if el is Pause:
		self.texture = load(_texture_paths["REST_"+el.type_to_string(el.get_type())])
		if el._dot:
			$Dot.visible = true
			$Dot.position += Vector2(80, 62)
	elif el is Note:
		if el.get_position() >= 6:
			self.texture = load(_texture_paths["NOTE_"+el.type_to_string(el.get_type())+"_REVERSE"])
			self.position.y+=93
		else:
			self.texture = load(_texture_paths["NOTE_"+el.type_to_string(el.get_type())])
			$Dot.position += Vector2(0, 93)
		if el.get_pedal_event() != null:
			if el.get_pedal_event().type == PedalMetaEvent.Type.PUSH:
				var pedal = Sprite2D.new()
				pedal.texture = load(_texture_paths["PEDAL_ON"])
				pedal.centered = false
				pedal.position = Vector2i(0, 720-pos.y-300)
				if el.get_position() >= 6:
					pedal.position.y -= 93
				add_child(pedal)
			else:
				var pedal = Sprite2D.new()
				pedal.texture = load(_texture_paths["PEDAL_OFF"])
				pedal.centered = false
				pedal.position = Vector2i(0, 720-pos.y-300)
				if el.get_position() >= 6:
					pedal.position.y -= 93
				add_child(pedal)
		if el._dot:
			$Dot.visible = true
			$Dot.position += Vector2(80, 0)
	elif el is Accidental:
		self.texture = load(_texture_paths["ACCIDENTAL_"+el.type_to_string(el.get_type())])
		self.position.y+=7
