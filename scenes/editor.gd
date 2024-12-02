extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(1<<16)
	MidiImport.load_file("./demos/furEliseDemo.mid")
	# MidiExport.save_file("./demos/furEliseDemoExport.mid")
	$Stave.setup_stave()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
