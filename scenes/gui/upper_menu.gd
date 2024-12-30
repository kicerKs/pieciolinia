extends Node2D

@onready var popup_exit = $PopUpExit
@onready var popup_load = $PopUpLoad
@onready var MIDI_save = $MIDI_Save
@onready var MIDI_load = $MIDI_Load

var _midi_load_continue = false

# Called when successfully loaded up a file
signal new_file_loaded

func _ready() -> void:
	MIDI_load.filters = ["*.mid"]
	MIDI_save.filters = ["*.mid"]
	
	var editor = get_node("/root/Main/Editor")
	new_file_loaded.connect(editor.initialize_editor)
	popup_exit.set_message("Czy na pewno chcesz wyłączyć program?")
	popup_load.set_message("Ten plik nie jest w 100% kompatybilny. Czy kontynuować wczytywanie?")

func _process(delta: float) -> void:
	pass


func _on_exit_button_button_down() -> void:
	popup_exit.show()


func _on_button_approved_button_down() -> void:
	get_tree().quit()


func _on_midi_save_file_selected(path: String) -> void:
	MidiExport.save_file(path)


func _on_midi_load_file_selected(path: String) -> void:
	await MidiImport.load_file(path, self)
	if(Global.max_track > 0):
		new_file_loaded.emit()

func _on_import_button_pressed() -> void: # otwórz/open
	MIDI_load.visible = true

func _on_export_button_pressed() -> void: # zapisz/save
	MIDI_save.visible = true

func _on_button_approve_midi_warn():
	_midi_load_continue = true

func continue_loading() -> bool:
	_midi_load_continue = false
	popup_load.show()
	await popup_load.action
	return _midi_load_continue
