extends Node
class_name TestNote

# Test 1 - Appropriate properties
func test_note_initialization():
	var note = Note.new(Note.NoteType.QUARTER, Note.ObjectType.NOTE)
	var rest = Note.new(Note.NoteType.QUARTER, Note.ObjectType.PAUZA)
	assert(note.isPause() == false, "The note should be of type Note, but it is recognized as a pause")
	assert(rest.isPause() == true, "The note shoulde be of type Rest, but it isn't recognized as a pause")

# test 2


# test 3


# test 4

#func run_tests():
	#test_note_initialization()
#
#func _ready():
	#run_tests()
