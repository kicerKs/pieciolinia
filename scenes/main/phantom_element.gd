extends TextureRect

var active = false

var note_names = ["WholeNote", "HalfNote", "QuarterNote", "EightNote", "SixteenthNote", "ThirtysecondNote"]
var pause_names = ["WholeRest", "HalfRest", "QuarterRest", "EightRest", "SixteenthRest", "ThirtysecondRest"]
var accidentals_names = ["Flat", "Natural", "Sharp"]

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
	"Dot": "res://assets/misc/dot.png",
	"PedalOn": "res://assets/misc/pedal_on.png",
	"PedalOff": "res://assets/misc/pedal_off.png",
	"Remove": "res://assets/misc/cross.png",
	"Dynamic": "res://assets/misc/dynamic.png",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action("rmb") and active:
		Global.reset_toolbox()
		deactivate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		position = get_global_mouse_position()+Vector2(10,10)

func set_active():
	active = true
	self.visible = true
	self.texture = load(_texture_paths[Global.toolbox_element])

func deactivate():
	active = false
	self.visible = false
