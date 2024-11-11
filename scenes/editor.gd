extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var fur_elise_track = MidiImport.new("./demos/furEliseDemo.mid").get_track()
	print(fur_elise_track)
	MidiExport.new("./demos/furEliseDemoExport.mid", fur_elise_track)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
