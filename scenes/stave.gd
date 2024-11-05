extends Node2D

var note_size = 75
var space_between_notes = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var measure_up = 4
	var measure_down = 4
	$Barline.position.x = 150 + (note_size + space_between_notes) * (measure_up * (16/measure_down)) + 10
	$MeasureDownLabel.text = str(measure_down)
	$MeasureUpLabel.text = str(measure_up)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
