extends Node2D

@onready var popup = $PopUpExit
@onready var MIDI_save = $MIDI_Save
@onready var MIDI_load = $MIDI_Load

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
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	#save_file.store_line("Example text123")

func _on_midi_load_file_selected(path: String) -> void:
	var load_file = FileAccess.open(path, FileAccess.READ)
	#if FileAccess.file_exists(path): // null
		#print(load_file.get_line())


func _on_import_button_pressed() -> void: # otwórz/open
	MIDI_load.visible = true

func _on_export_button_pressed() -> void: # zapisz/save
	MIDI_save.visible = true
