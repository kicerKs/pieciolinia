extends Node2D

@export var stave: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(1<<16)
	MidiImport.load_file("./demos/furEliseDemo.mid")
	Global.max_track = len(Melody.tracks)-1
	# MidiExport.save_file("./demos/furEliseDemoExport.mid")
	for i in range(len(Melody.tracks)):
		print(i)
		var new_stave = stave.instantiate()
		add_child(new_stave)
		new_stave.setup_stave(i)
	#$Stave.setup_stave()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
