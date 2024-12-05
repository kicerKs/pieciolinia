extends Node2D

@onready var popup = $PopUpExit
@onready var MIDI_save = $MIDI_Save
@onready var MIDI_load = $MIDI_Load

@export var stave: PackedScene

func _ready() -> void:
	MIDI_save.current_dir = "/"
	pass 


func _process(delta: float) -> void:
	pass


func _on_exit_button_button_down() -> void:
	popup.show()


func _on_pop_up_exit_close_requested() -> void:
	popup.hide()


func _on_button_approved_button_down() -> void:
	get_tree().quit()


func _on_button_discard_button_down() -> void:
	popup.hide()


func _on_midi_save_file_selected(path: String) -> void:
	#var save_file = FileAccess.open(path, FileAccess.WRITE)
	#save_file.store_line("Example text123")
	MidiExport.save_file(path)

func _on_midi_load_file_selected(path: String) -> void:
	print(1<<16)
	#MidiImport.load_file(path)
	MidiImport.load_file("res://demos/furEliseDemo.mid")
	Global.max_track = len(Melody.tracks)-1
	for i in range(len(Melody.tracks)):
		print(i)
		var new_stave = stave.instantiate()
		add_child(new_stave)
		new_stave.setup_stave(i)
	
	$Stave.setup_stave()
	
	#var load_file = FileAccess.open(path, FileAccess.READ)
	#if FileAccess.file_exists(path): i sprawdz czy jest rozna od null
		#print(load_file.get_line())


func _on_import_button_pressed() -> void: # otwórz/open
	MIDI_load.visible = true

func _on_export_button_pressed() -> void: # zapisz/save
	MIDI_save.visible = true
