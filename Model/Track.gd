class_name Track

const MIN_OCTAVE: int = 0
const MAX_OCTAVE: int = 9
const MIN_RATE: int = 0
const MAX_RATE: int = 100
const MIN_METER_TOP: int = 1
const MAX_METER_TOP: int = 12
const MIN_METER_BOTTOM: int = 1
const MAX_METER_BOTTOM: int = 16

var _octave: int
var _meter_bottom: int
var _meter_top: int
var _rate: int
@export var _instrument = Instruments.Instrument.ACOUSTIC_GRAND_PIANO
var _notes: Array[Note] = []

func _init(rate: int, meter_top: int, meter_bottom: int, octave: int, instrument: int, notes: Array[Note]):
	self._rate = rate
	self._meter_top = meter_top
	self._meter_bottom = meter_bottom
	self._octave = octave
	self._instrument = instrument
	self._notes = notes
	# Wouldn't it be better to do it this way? self.rate = rate -> self.set_rate(rate)


func _to_string() -> String:
	return "Track: rate = %d, meter = %d/%d, octave = %d, intrument = %d, notes count = %d" % [_rate, _meter_top, _meter_bottom, _octave, _instrument, _notes.size()]

func setRate(rate: int):
	self._rate = clamp(rate, MIN_RATE, MAX_RATE)

func setMeter(meter_top: int, meter_botton: int):
	self._meter_bottom = clamp(_meter_bottom, MIN_METER_BOTTOM, MAX_METER_BOTTOM)
	self._meter_top = clamp(_meter_top, MIN_METER_TOP, MAX_METER_TOP)

func setOctave(octave: int):
	self._octave = clamp(_octave, MIN_OCTAVE, MAX_OCTAVE)

func setInstrument(instrument: Instruments.Instrument):
	if instrument in range(Instruments.Instrument.ACOUSTIC_GRAND_PIANO, Instruments.Instrument.GUNSHOT + 1):
		self._instrument = instrument
	else:
		push_error("Invalid instrument value %d. We don't have this instrument yet." % instrument)

func setNotes(notes: Array[Note]):
	self._notes = notes


func getRate() -> int:
	return _rate

func getMeterTop() -> int:
	return _meter_top
	
func getMeterBottom() -> int:
	return _meter_bottom

func getOctave() -> int:
	return _octave

func getInstrument() -> Instruments.Instrument:
	return _instrument

func getNotes() -> Array[Note]:
	return _notes
