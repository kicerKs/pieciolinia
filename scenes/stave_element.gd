extends Node2D

var barline = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup(bar_number: int, text: String, pos: Vector2i):
	barline = bar_number
	self.texture = load(text)
	self.position = pos
