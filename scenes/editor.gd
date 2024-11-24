extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var import = NewMidiImport.new()
	import.load_file("./demos/furEliseDemo.mid")
	print(str(Melody.tracks[0]))
	print(str(Melody.tracks[0].get_bars()[0]))
	# MidiExport.save_file("./demos/furEliseDemoExport.mid")
	$Stave.setup_stave()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
