extends "res://addons/gut/test.gd"
class_name TestMidiExport

@onready var track = preload("res://Model/Track.gd").new(60, 4, 4, 5, Instruments.Instrument.ACOUSTIC_GRAND_PIANO, [])
var music_exporter: MidiExport 

func test_export_data(): # Check if file starts with the MThd header 
	var note1 = Note.new(Note.NoteType.WHOLE, Note.ObjectType.NOTE, 60)
	var note2 = Note.new(Note.NoteType.QUARTER, Note.ObjectType.NOTE, 64)
	var note3 = Note.new(Note.NoteType.HALF, Note.ObjectType.PAUZA)
	
	var notes: Array[Note] = [note1, note2, note3]
	track.setNotes(notes)
	
	music_exporter = MidiExport.new("res://Model/filename.mid", track)
	music_exporter._file.close()
#
	var file = FileAccess.open("res://Model/filename.mid", FileAccess.READ)
	var exported_data = file.get_as_text()
	
	assert_true(exported_data != null)
	assert_string_starts_with(exported_data, "MThd")
	
	file.close()
	
