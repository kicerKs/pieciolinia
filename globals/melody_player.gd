extends Node

@onready var player: MidiPlayer = get_node("/root/Main/GodotMIDIPlayer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play() -> bool:
	clear_temp()
	var path = "./.temp/" + Time.get_time_string_from_system().replace(':','_') +".mid"
	var succes = MidiExport.save_file(path)
	if(succes and Melody.tracks.size()>0):
		player.file = path
		player.volume_db = Melody.volume*40/100 - 40
		#player.next_note.connect(test)
		player.play()
		return true
	return false

func clear_temp():
	if(!DirAccess.open("./").dir_exists(".temp")):
		DirAccess.open("./").make_dir(".temp")
	var dir = DirAccess.open("./.temp")
	for file in dir.get_files():
		dir.remove(file)

func stop():
	player.stop()
