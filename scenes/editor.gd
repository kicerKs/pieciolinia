extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MidiImport.load_file("./demos/furEliseDemo.mid")
	var fur_elise_track = Global.current_track
	print(fur_elise_track)
	MidiExport.save_file("./demos/furEliseDemoExport.mid")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
