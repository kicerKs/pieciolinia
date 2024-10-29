extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var furEliseTrack = MidiImport.new("./demos/furEliseDemo.mid").getTrack()
	print(furEliseTrack)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
