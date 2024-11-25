extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MidiImport.load_file("./demos/furEliseDemo.mid")
	print(str(Melody.tracks[0]))
	print(str(Melody.tracks[0].get_bars()[0]))
	for j in range(3):
		print(j)
		for i in range(Melody.tracks[0].get_bars()[j].get_elements().size()):
			print(str(Melody.tracks[0].get_bars()[j].get_elements()[i]))
	# MidiExport.save_file("./demos/furEliseDemoExport.mid")
	$Stave.new_setup_stave()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
