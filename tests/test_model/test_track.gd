extends "res://addons/gut/test.gd"
class_name TestTrack

# Test 1 - check initialization
func test_initialization():
	var note: Array[Note] = [Note.new(Note.NoteType.SIXTEENTH, Note.ObjectType.NOTE, 60)]
	var track = Track.new(60, 4, 3, 5, Track.Instrument.ACOUSTIC_BASS, note)
	assert_eq(track.getRate(), 60)
	assert_eq(track.getMeterTop(), 4)
	assert_eq(track.getMeterBottom(), 3)
	assert_eq(track.getOctave(), 5)
	assert_eq(track.getInstrument(), Track.Instrument.ACOUSTIC_BASS)
	assert_eq(track.getNotes().size(), 1)
	
# Test 2 - Check if setNotes set list of notes in appropriate way
func test_set_notes():
	var note1 = Note.new(Note.NoteType.WHOLE, Note.ObjectType.NOTE, 60)
	var note2 = Note.new(Note.NoteType.QUARTER, Note.ObjectType.NOTE, 64)
	var note3 = Note.new(Note.NoteType.HALF, Note.ObjectType.PAUZA)
	var notes: Array[Note] = [note1, note2, note3]
	var track = Track.new(60, 4, 4, 5, Track.Instrument.ACOUSTIC_GRAND_PIANO, [])
	track.setNotes(notes)
	
	# Check if we have 3 notes
	assert_eq(track.getNotes().size(), 3)
	
	# Check every single note
	assert_eq(track.getNotes()[0]._to_string(), "Note: type = WHOLE, isPause = false, sound = 60")
	assert_eq(track.getNotes()[1]._to_string(), "Note: type = QUARTER, isPause = false, sound = 64")
	assert_eq(track.getNotes()[2]._to_string(), "Note: type = HALF, isPause = true, sound = -1")
	
# Test 3 - Check methods: setRate, setMeter, setOctave - especially check the correctness of the values
func test_set_rate():
	var track = Track.new(0, 4, 4, 5, Track.Instrument.ACCORDION, [])
	
	track.setRate(110)
	assert_eq(track.getRate(), Track.MAX_RATE)
	
	track.setRate(-5)
	assert_eq(track.getRate(), Track.MIN_RATE)
	
func test_set_meter():
	var track = Track.new(0, 4, 4, 5, Track.Instrument.ACCORDION, [])

	# bottom: min, top: min
	track.setMeter(-5, -1)
	assert_eq(track.getMeterBottom(), Track.MIN_METER_BOTTOM)
	assert_eq(track.getMeterTop(), Track.MIN_METER_TOP)
	
	# bottom: max, top: max
	track.setMeter(17, 13)
	assert_eq(track.getMeterBottom(), Track.MAX_METER_BOTTOM)
	assert_eq(track.getMeterTop(), Track.MAX_METER_TOP)
	
	# bottom: min, top: max
	track.setMeter(-3, 14)
	assert_eq(track.getMeterBottom(), Track.MIN_METER_BOTTOM)
	assert_eq(track.getMeterTop(), Track.MAX_METER_TOP)
	
	# bottom: max, top: min
	track.setMeter(18, 1)
	assert_eq(track.getMeterBottom(), Track.MAX_METER_BOTTOM)
	assert_eq(track.getMeterTop(), Track.MIN_METER_TOP)
	
func test_set_octave():
	var track = Track.new(0, 4, 4, 5, Track.Instrument.ACCORDION, [])
	
	track.setOctave(-1)
	assert_eq(track.getOctave(), Track.MIN_OCTAVE)
	
	track.setOctave(11)
	assert_eq(track.getOctave(), Track.MAX_OCTAVE)

# Test 4 - Check correct instrument properties
func test_set_instrument():
	var track = Track.new(0, 4, 4, 5, Track.Instrument.ACCORDION, [])
	track.setInstrument(Track.Instrument.CELESTA)
	assert_eq(track.getInstrument(), Track.Instrument.CELESTA)
	
	track.setInstrument(-1) # Checking what happens in case of a wrong value
	assert_eq(track.getInstrument(), -1)
	
# Test 5 - Check to_string method
func test_to_string():
	var track = Track.new(10, 4, 4, 5, Track.Instrument.ACCORDION, [])
	var track_str = track._to_string()
	assert_string_contains(track_str, "rate = 10")
	assert_string_contains(track_str, "meter = 4/4")
	assert_string_contains(track_str, "octave = 5")
