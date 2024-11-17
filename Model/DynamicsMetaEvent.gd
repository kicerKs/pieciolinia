class_name DynamicsMetaEvent

enum Type{ PPP = 16, PP = 32, P = 48, MP = 64, MF = 80, F=96, FF = 112, FFF = 127}

var type: Type

func _init(type: Type):
	self.type = type
