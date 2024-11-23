class_name StaffDrawable extends Node

var _position: int #0-14 oktawa razkreślna + dwukreślna inne pozycje dla elementów poza nutami, pazuzami i znak. chrom.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_position() -> int:
	return _position
