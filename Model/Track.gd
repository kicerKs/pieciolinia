class_name Track

#publicznie dostępne
var bars: Array[Bar] = []
var key: KeyType = KeyType.TREBLE
var key_signature: KeySygnature = KeySygnature.C
var _instrument = Instruments.Instrument.ACOUSTIC_GRAND_PIANO

func initialize(bars: Array[Bar] = [], key: KeyType = KeyType.TREBLE , key_signature: KeySygnature= KeySygnature.C):
	self.bars = bars
	self.key = key
	self.key_signature = key_signature

func add_bar(bar: Bar):
	bars.append(bar)

func set_key_type(key: KeyType):
	self.key = key

func set_key_signature(key_signature: KeySygnature):
	self.key_signature = key_signature

func set_instrument(instrument: Instruments.Instrument):
	_instrument = instrument

func get_bars() -> Array[Bar]:
	return bars

func get_key_type() -> KeyType:
	return key

func get_key_signature() -> KeySygnature:
	return key_signature

func get_instrument() -> Instruments.Instrument:
	return _instrument

func _to_string() -> String:
	return "Track: key = %d, key sygnatire = %d, intrument = %d, bar count = %d" % [key, key_signature, _instrument, bars.size()]

func save():
	var save_dict = {
		"key": key,
		"key_signature": key_signature,
		"_instrument": _instrument,
		"bars": serializeBarsToJson(),
	}
	return save_dict

func serializeBarsToJson():
	var json_array = []
	for bar in bars:
		json_array.append(bar.save())
	return json_array

enum KeyType{
	BASS = 0, 
	TREBLE = 1,
	}
enum KeySygnature{
	CES = -7, 
	GES = -6,
	DES = -5, 
	AS =- 4, 
	ES = -3, 
	B =-2, 
	F = -1, 
	C = 0,
	G = 1,
	D = 2,
	A = 3,
	E = 4,
	H = 5,
	FIS = 6,
	CIS = 7,
	}
enum KeySygnatureMajorNames{
		AS = -7,
		ES = -6,
		B = -5,
		F =- 4,
		C = -3,
		G =-2,
		D = -1,
		A = 0,
		E = 1,
		H = 2,
		FIS = 3,
		CIS = 4,
		GIS = 5,
		DIS = 6,
		AIS = 7,
	}
