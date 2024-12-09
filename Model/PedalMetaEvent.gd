class_name PedalMetaEvent

enum Type{ 
	PUSH = 1,
	RELEASE = 0,
}

var type

func _init(type: Type):
	self.type = type
