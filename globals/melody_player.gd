extends Node

@onready var player: MidiPlayer = get_node("/root/Main/GodotMIDIPlayer")

static var noteIndicator = []
signal finished(bool)
signal start_playing
signal stop_playing


func _ready() -> void:
	player.finished.connect(melodyFinished)

func play() -> bool:
	clear_temp()
	var path = "./.temp/" + Time.get_time_string_from_system().replace(':','_') +".mid"
	var succes = MidiExport.save_file(path)
	if(succes and Melody.tracks.size()>0):
		resetNoteIndicators()
		player.file = path
		player.next_note.connect(moveIndicator)
		player.play()
		start_playing.emit()
		return true
	return false

func resetNoteIndicators():
	noteIndicator = []
	noteIndicator.resize(Melody.tracks.size())
	for x in range(Melody.tracks.size()):
		noteIndicator[x] = 0

func moveIndicator(staff: int):
	noteIndicator[staff] += 1

func get_position_on_staff(staff_index: int) -> int:
	if(staff_index >= 0 and staff_index < noteIndicator.size()):
		return noteIndicator[staff_index]
	return 0 

func clear_temp():
	if(!DirAccess.open("./").dir_exists(".temp")):
		DirAccess.open("./").make_dir(".temp")
	var dir = DirAccess.open("./.temp")
	for file in dir.get_files():
		dir.remove(file)

func stop():
	player.stop()
	stop_playing.emit()

func melodyFinished():
	finished.emit(false)
