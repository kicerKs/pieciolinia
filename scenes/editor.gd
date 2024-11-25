extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MidiImport.load_file("./demos/furEliseDemo2.mid")
	print(str(Melody.tracks[0]))
	print(str(Melody.tracks[1]))
	print(str(Melody.tracks[0].get_bars()[0]))
	print("trzy pierwsze bary")
	for k in range(Melody.tracks.size()):
		print(k)
		for j in range(Melody.tracks[k].get_bars().size()):
			print(j)
			for i in range(Melody.tracks[k].get_bars()[j].get_elements().size()):
				print(str(Melody.tracks[k].get_bars()[j].get_elements()[i]))
	# MidiExport.save_file("./demos/furEliseDemoExport.mid")
	$Stave.setup_stave()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
