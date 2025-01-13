class_name DynamicsMetaEvent

enum Type{ PPP = 16, PP = 32, P = 48, MP = 64, MF = 80, F=96, FF = 112, FFF = 127}

var type: Type

func _init(type: Type):
	self.type = type

static func create_from_int(value: int) -> DynamicsMetaEvent:
	var instance = DynamicsMetaEvent.new(from_int(value))
	return instance

static func from_int(value: int) -> Type:
	match value:
		16:
			return Type.PPP
		32:
			return Type.PP
		48:
			return Type.P
		64:
			return Type.MP
		80:
			return Type.MF
		96:
			return Type.F
		112:
			return Type.FF
		127:
			return Type.FFF
		_:
			return Type.PP

func save():
	var save_dict = {
		"type": type,
	}
	return save_dict
