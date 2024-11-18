class_name Track

enum KeyType{BASS = 0, TREBLE = 1}
enum KeySygnature{CES = -7, GES = -6, DES = -5, AS =- 4, ES = -3, B =-2, F = -1, C = 0,G = 1,D = 2,A = 3,E = 4,H = 5,FIS = 6,CIS = 7}

#publicznie dostępne
var bars: Array[Bar]
var key: KeyType
var keySignature: KeySygnature

func _init(bars: Array[Bar] = [], key: KeyType = KeyType.TREBLE , keySignature: KeySygnature= KeySygnature.C):
	self.bars = bars
	self.key = key
	self.keySignature = keySignature

func add_bar(bar: Bar):
	bars.append(bar)

func set_key_type(key: KeyType):
	self.key = key

func set_key_signature(keySignature: KeySygnature):
	self.keySignature = keySignature

func get_bars() -> Array[Bar]:
	return bars

func get_key_type() -> KeyType:
	return key

func get_key_signature() -> KeySygnature:
	return keySignature
