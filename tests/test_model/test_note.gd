extends "res://addons/gut/test.gd"
class_name TestNote

# Test 1 - Appropriate properties
func test_note_initialization():
	var note = Note.new(Note.NoteType.QUARTER, Note.ObjectType.NOTE)
	var rest = Note.new(Note.NoteType.QUARTER, Note.ObjectType.PAUZA)
	assert_false(note.isPause(), "The note should be of type Note, but it is recognized as a pause")
	assert_true(rest.isPause(), "The note shoulde be of type Rest, but it isn't recognized as a pause")

# test 2 - Check if note is a pauze
func test_note_as_pauze():
	var note = Note.new(Note.NoteType.QUARTER, Note.ObjectType.PAUZA)
	assert_eq(note.isPause(), true)
	assert_eq(note.getSound(), -1)

# test 3 - Check appropriate type of notes (during creation)
func test_note_creation():
	var cases = [
		{"type": Note.NoteType.WHOLE, "object": Note.ObjectType.NOTE, "sound": 60, "expected_sound": 60, "is_pause": false},
		{"type": Note.NoteType.HALF, "object": Note.ObjectType.PAUZA, "sound": 80, "expected_sound": -1, "is_pause": true},
		{"type": Note.NoteType.QUARTER, "object": Note.ObjectType.NOTE, "sound": -10, "expected_sound": 0, "is_pause": false},
		{"type": Note.NoteType.EIGHTH, "object": Note.ObjectType.NOTE, "sound": 130, "expected_sound": 127, "is_pause": false}
	]
	
	for case in cases:
		var note = Note.new(case["type"], case["object"], case["sound"])
		assert_eq(note.getType(), case["type"])
		assert_eq(note.isPause(), case["is_pause"])
		assert_eq(note.getSound(), case["expected_sound"])
		
	#var note = Note.new(Note.NoteType.WHOLE, Note.ObjectType.NOTE, 60)
	#assert_eq(note.getType(), Note.NoteType.WHOLE)
	#assert_false(note.isPause())
	#assert_eq(note.getSound(), 60)
	

# test 4 - Check correctnesss of longest/shortest notes
func test_note_length_correctness():
	# the longest one
	var whole_note = Note.new(Note.NoteType.WHOLE, Note.ObjectType.NOTE, 60)
	assert_eq(whole_note.getType(), Note.NoteType.WHOLE)	
	
	# the shortest one 
	var sixteenth_note = Note.new(Note.NoteType.SIXTEENTH, Note.ObjectType.NOTE, 60)
	assert_eq(sixteenth_note.getType(), Note.NoteType.SIXTEENTH)
	
	
