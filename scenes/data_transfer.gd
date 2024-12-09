extends Node2D

@onready var popup = $PopUpExit
@onready var MIDI_save = $MIDI_Save
@onready var MIDI_load = $MIDI_Load

var editor_scene = preload("res://scenes/editor.tscn")
var editor = null

func _ready() -> void:
	MIDI_load.filters = ["*.mid"]
	MIDI_save.filters = ["*.mid"]


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
	MidiExport.save_file(path)


func _on_midi_load_file_selected(path: String) -> void:
	MidiImport.load_file(path)
	Global.max_track = len(Melody.tracks)-1
	
	if editor == null:
		editor = editor_scene.instantiate()
		add_child(editor)
	if editor != null:
		editor.initialize_editor()

func _on_import_button_pressed() -> void: # otwórz/open
	MIDI_load.visible = true

func _on_export_button_pressed() -> void: # zapisz/save
	MIDI_save.visible = true
