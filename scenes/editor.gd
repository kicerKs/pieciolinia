extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var fur_elise_track = MidiImport.new("./demos/furEliseDemo.mid").get_track()
	print(fur_elise_track.get_notes())
	MidiExport.new("./demos/mario.mid", mario())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func mario() -> Track:
	return Track.new(80, 4, 4, 5, Instruments.Instrument.ACOUSTIC_GRAND_PIANO, [
	Note.new(Note.NoteType.EIGHTH, Note.ObjectType.NOTE, 16), 
	Note.new(Note.NoteType.EIGHTH, Note.ObjectType.NOTE, 16), 
	Note.new(Note.NoteType.EIGHTH, Note.ObjectType.PAUSE),
	Note.new(Note.NoteType.EIGHTH, Note.ObjectType.NOTE, 16), 
	Note.new(Note.NoteType.EIGHTH, Note.ObjectType.PAUSE),
	Note.new(Note.NoteType.EIGHTH, Note.ObjectType.NOTE, 12), 
	Note.new(Note.NoteType.QUARTER, Note.ObjectType.NOTE, 16), 
	Note.new(Note.NoteType.QUARTER, Note.ObjectType.NOTE, 19), 
	Note.new(Note.NoteType.QUARTER, Note.ObjectType.PAUSE),
	Note.new(Note.NoteType.QUARTER, Note.ObjectType.NOTE, 7), 
	Note.new(Note.NoteType.QUARTER, Note.ObjectType.PAUSE),
	Note.new(Note.NoteType.QUARTER, Note.ObjectType.NOTE, 12), 
	Note.new(Note.NoteType.EIGHTH, Note.ObjectType.PAUSE),
	Note.new(Note.NoteType.QUARTER, Note.ObjectType.NOTE, 7), 
	Note.new(Note.NoteType.EIGHTH, Note.ObjectType.PAUSE),
	Note.new(Note.NoteType.QUARTER, Note.ObjectType.NOTE, 4), 
	Note.new(Note.NoteType.EIGHTH, Note.ObjectType.PAUSE),
	Note.new(Note.NoteType.EIGHTH, Note.ObjectType.NOTE, 9), 
	Note.new(Note.NoteType.QUARTER, Note.ObjectType.NOTE, 11), 
	Note.new(Note.NoteType.EIGHTH, Note.ObjectType.NOTE, 11, Note.Pitch.LOWER), 
	Note.new(Note.NoteType.QUARTER, Note.ObjectType.NOTE, 9), 
	Note.new(Note.NoteType.QUARTER, Note.ObjectType.NOTE, 7), 
	Note.new(Note.NoteType.QUARTER, Note.ObjectType.NOTE, 16), 
	Note.new(Note.NoteType.QUARTER, Note.ObjectType.NOTE, 19), 
	Note.new(Note.NoteType.QUARTER, Note.ObjectType.NOTE, 21), 
	Note.new(Note.NoteType.EIGHTH, Note.ObjectType.NOTE, 17), 
	Note.new(Note.NoteType.EIGHTH, Note.ObjectType.NOTE, 19), 
	Note.new(Note.NoteType.EIGHTH, Note.ObjectType.PAUSE),
	Note.new(Note.NoteType.EIGHTH, Note.ObjectType.NOTE, 9), 
	])
