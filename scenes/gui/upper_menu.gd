extends CanvasLayer

@onready var popup_exit = $PopUpExit
@onready var popup_load = $PopUpLoad
@onready var popup_message = $PopUpMessage
@onready var MIDI_save = $MIDI_Save
@onready var Staff_save = $Staff_Save
@onready var MIDI_load = $MIDI_Load

var _midi_load_continue = false

# Called when successfully loaded up a file
signal new_file_loaded

func _ready() -> void:
	MIDI_load.filters = ["*.mid","*.staff"]
	MIDI_save.filters = ["*.mid"]
	Staff_save.filters = ["*.staff"]
	
	var editor = get_node("/root/Main/Editor")
	new_file_loaded.connect(editor.initialize_editor)
	popup_exit.set_message("Czy na pewno chcesz wyłączyć program?")
	MelodyPlayer.finished.connect(_play_melody)
	

func _process(delta: float) -> void:
	pass

func _play_melody(play: bool):
	if(play):
		var success = MelodyPlayer.play()
		if(!success):
			showMessage("Utwór zawiera błędy, odtworzenie jest niemożliwe")
		$Control/MarginContainer/HBoxContainer/PlayButton.button_pressed = success
		lock_controls(success)
	else:
		MelodyPlayer.stop()
		$Control/MarginContainer/HBoxContainer/PlayButton.button_pressed = false
		lock_controls(false)

func lock_controls(lock: bool):
	$Control/MarginContainer/HBoxContainer/HBoxContainer/RateSlider.editable = !lock
	$Control/MarginContainer/HBoxContainer/NewButton.disabled = lock
	$Control/MarginContainer/HBoxContainer/ImportButton.disabled = lock
	$Control/MarginContainer/HBoxContainer/SaveButton.disabled = lock
	$Control/MarginContainer/HBoxContainer/ExportButton.disabled = lock

func _on_exit_button_button_down() -> void:
	popup_exit.show()


func _on_button_approved_button_down() -> void:
	get_tree().quit()


func _on_midi_save_file_selected(path: String) -> void:
	var success = MidiExport.save_file(path)
	if(!success):
		showMessage("Utwór zawiera błędy lub jest pusty, eksport jest niemożliwy")

func _on_staff_save_file_selected(path: String) -> void:
	var success =  MelodySaver.save_melody(path)
	if(!success):
		showMessage("Utwór zawiera błędy lub jest pusty, eksport jest niemożliwy")

func _on_midi_load_file_selected(path: String) -> void:
	if(path.right(4) == ".mid"):
		var success = await MidiImport.load_file(path, self)
		if(!success):
			showMessage("Plik ma zły format lub jest pusty, import jest niemożliwy")
		if(Global.max_track > 0):
			new_file_loaded.emit()
	else:
		var success = await MelodyLoader.melody_load(path)
		if(!success):
			showMessage("Plik ma zły format lub jest pusty, odczyt jest niemożliwy")
		new_file_loaded.emit()

func showMessage(message: String):
	popup_message.set_message("Plik ma zły format lub jest pusty, odczyt jest niemożliwy")
	popup_message.show(CustomPopup.ButtonOption.OK)

func _on_import_button_pressed() -> void: # otwórz/open
	_midi_load_continue = false
	popup_load.set_message("Wszelkie niezapisane zmiany zostaną utracone. Czy na pewno chcesz wczytać inny plik?")
	if(Melody.tracks.size() > 0): 
		popup_load.show()
		await popup_load.action
	if(_midi_load_continue or Melody.tracks.size() == 0):
		MIDI_load.visible = true

func _on_export_button_pressed() -> void: # zapisz/save
	MIDI_save.visible = true

func _on_save_button_pressed() -> void: # zapisz/save
	Staff_save.visible = true

func _on_button_approve_midi_warn():
	_midi_load_continue = true

func continue_loading() -> bool:
	_midi_load_continue = false
	popup_load.set_message("Ten plik nie jest w 100% kompatybilny. Czy kontynuować wczytywanie?")
	popup_load.show()
	await popup_load.action
	return _midi_load_continue


func _on_new_button_pressed() -> void:
	$PopUpNewDocument.show()
