extends Node2D

@export var stave: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Melody.melody_changed.connect(initialize_editor)
	Melody.clear()
	initialize_editor()

func initialize_editor() -> void:
	for stave in get_tree().get_nodes_in_group("staves"):
		remove_child(stave)
		stave.queue_free()
	for i in range(len(Melody.tracks)):
		var new_stave = stave.instantiate()
		add_child(new_stave)
		new_stave.name = "Stave"+str(i)
		MelodyPlayer.connect("start_playing", new_stave.start_playing)
		MelodyPlayer.connect("stop_playing", new_stave.reset_playing)
		get_node("/root/Main/GodotMIDIPlayer").connect("next_note", new_stave.move_player_to_next_note)
		new_stave.setup_stave(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
