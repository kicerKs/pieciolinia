class_name melodySaver extends Node


func save_melody():
	var melody = Melody
	var scene = PackedScene.new()
	var result = scene.pack(melody)
	if result == OK:
		var error = ResourceSaver.save(scene, "res://saveTest.tscn")
		if error != OK:
			push_error("An error occurred while saving the scene to disk.")
