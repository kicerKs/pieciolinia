extends Node2D

@export var stave: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func initialize_editor() -> void:
	for stave in get_tree().get_nodes_in_group("staves"):
		remove_child(stave)
		stave.queue_free()
	for i in range(len(Melody.tracks)):
		var new_stave = stave.instantiate()
		add_child(new_stave)
		new_stave.name = "Stave"+str(i)
		new_stave.setup_stave(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
