extends Control

var barline = null
var staffDrawable: StaffDrawable
var old_pos
# For Drag&Drop
var selected = false 
var dnd_position

signal dnd_activated
signal dnd_deactivated

var _texture_paths = {
	"NOTE_WHOLE": "res://assets/notes/whole_note.png",
	"NOTE_HALF": "res://assets/notes/half_note.png",
	"NOTE_QUARTER": "res://assets/notes/quarter_note.png",
	"NOTE_EIGHT": "res://assets/notes/eight_note.png",
	"NOTE_SIXTEENTH": "res://assets/notes/sixteenth_note.png",
	"NOTE_THIRTYSECOND": "res://assets/notes/thirtysecond_note.png",
	"NOTE_WHOLE_REVERSE": "res://assets/notes/reverse_whole_note.png",
	"NOTE_HALF_REVERSE": "res://assets/notes/reverse_half_note.png",
	"NOTE_QUARTER_REVERSE": "res://assets/notes/reverse_quarter_note.png",
	"NOTE_EIGHT_REVERSE": "res://assets/notes/reverse_eight_note.png",
	"NOTE_SIXTEENTH_REVERSE": "res://assets/notes/reverse_sixteenth_note.png",
	"NOTE_THIRTYSECOND_REVERSE": "res://assets/notes/reverse_thirtysecond_note.png",
	"REST_WHOLE": "res://assets/rests/whole_rest.png",
	"REST_HALF": "res://assets/rests/half_rest.png",
	"REST_QUARTER": "res://assets/rests/quarter_rest.png",
	"REST_EIGHT": "res://assets/rests/eight_rest.png",
	"REST_SIXTEENTH": "res://assets/rests/sixteenth_rest.png",
	"REST_THIRTYSECOND": "res://assets/rests/thirtysecond_rest.png",
	"ACCIDENTAL_SHARP": "res://assets/accidentals/sharp.png",
	"ACCIDENTAL_NATURAL": "res://assets/accidentals/natural.png",
	"ACCIDENTAL_FLAT": "res://assets/accidentals/flat.png",
	"PEDAL_ON": "res://assets/misc/pedal_on.png",
	"PEDAL_OFF": "res://assets/misc/pedal_off.png",
}

func setup(bar_number: int, el: StaffDrawable, pos: Vector2i):
	barline = bar_number
	staffDrawable = el
	old_pos = pos
	self.position = pos
	if el is Pause:
		self.texture = load(_texture_paths["REST_"+el.type_to_string(el.get_type())])
		if el._dot:
			$Dot.visible = true
			$Dot.position += Vector2(80, 62)
	elif el is Note:
		if el.get_position() >= 6:
			self.texture = load(_texture_paths["NOTE_"+el.type_to_string(el.get_type())+"_REVERSE"])
			self.position.y+=93
		else:
			self.texture = load(_texture_paths["NOTE_"+el.type_to_string(el.get_type())])
			$Dot.position += Vector2(0, 93)
		if el.get_pedal_event() != null:
			if el.get_pedal_event().type == PedalMetaEvent.Type.PUSH:
				var pedal = Sprite2D.new()
				pedal.texture = load(_texture_paths["PEDAL_ON"])
				pedal.centered = false
				pedal.position = Vector2i(0, 720-pos.y-300)
				if el.get_position() >= 6:
					pedal.position.y -= 93
				add_child(pedal)
				pedal.name = "Pedal"
			else:
				var pedal = Sprite2D.new()
				pedal.texture = load(_texture_paths["PEDAL_OFF"])
				pedal.centered = false
				pedal.position = Vector2i(0, 720-pos.y-300)
				if el.get_position() >= 6:
					pedal.position.y -= 93
				add_child(pedal)
				pedal.name = "Pedal"
		if el.has_dynamic_event():
			var dyn = Label.new()
			match el.get_dynamic_event().type:
				DynamicsMetaEvent.Type.PPP:
					dyn.text = "ppp"
				DynamicsMetaEvent.Type.PP:
					dyn.text = "pp"
				DynamicsMetaEvent.Type.P:
					dyn.text = "p"
				DynamicsMetaEvent.Type.MP:
					dyn.text = "mp"
				DynamicsMetaEvent.Type.MF:
					dyn.text = "mf"
				DynamicsMetaEvent.Type.F:
					dyn.text = "f"
				DynamicsMetaEvent.Type.FF:
					dyn.text = "ff"
				DynamicsMetaEvent.Type.FFF:
					dyn.text = "fff"
			dyn.position = Vector2i(0, 720-pos.y-360)
			dyn.set("theme_override_colors/font_color",Color(Color.BLACK))
			dyn.set("theme_override_font_sizes/font_size", 25)
			add_child(dyn)
			dyn.name = "Dynamic"
		if el._dot:
			$Dot.visible = true
			$Dot.position += Vector2(80, 0)
	elif el is Accidental:
		self.texture = load(_texture_paths["ACCIDENTAL_"+el.type_to_string(el.get_type())])
		self.position.y+=7
	dnd_position = self.position

func _process(delta: float) -> void:
	if selected:
		print("MOVE?")
		global_position = lerp(global_position, get_global_mouse_position()-Vector2(35,60), 25 * delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and selected:
			print("INPUT3")
			selected = false
			var changed = false
			for c in get_tree().get_nodes_in_group("vacant_spaces"+str(get_parent().stave_number)):
				if c.position <= get_global_mouse_position() and c.position+c.size >= get_global_mouse_position():
					print("Moved element")
					print(c.name)
					if staffDrawable is not Pause:
						staffDrawable._position = 14-int(c.get_local_mouse_position().y/17)
					get_parent().replace_element(self, c)
					changed = true
					break
			if !changed:
				position = dnd_position
			Global.dnd_element = null
			dnd_deactivated.emit()
		elif selected and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			remove()

var note_names = ["WholeNote", "HalfNote", "QuarterNote", "EightNote", "SixteenthNote", "ThirtysecondNote"]
var pause_names = ["WholeRest", "HalfRest", "QuarterRest", "EightRest", "SixteenthRest", "ThirtysecondRest"]
var accidentals_names = ["Flat", "Natural", "Sharp"]
var misc = ["Dot", "PedalOn", "PedalOff", "Dynamic"]

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == 1 and not get_parent().playing:
		print("StaveElement onguiinput")
		if Global.toolbox_element == null:
			# Initiate Drag&Drop
			print("INIT DND")
			print(selected)
			selected = true
			dnd_position = position
			print(selected)
			Global.dnd_element = staffDrawable
			dnd_activated.emit()
		elif Global.toolbox_element in misc and staffDrawable is Note:
			var xd
			if staffDrawable is Pause:
				xd = staffDrawable as Pause
			elif staffDrawable is Note:
				xd = staffDrawable as Note
			match Global.toolbox_element:
				"Dot":
					staffDrawable._dot = !staffDrawable._dot
				"PedalOn":
					if staffDrawable._pedalMetaEvent == null:
						staffDrawable._pedalMetaEvent = PedalMetaEvent.new(PedalMetaEvent.Type.PUSH)
					elif staffDrawable._pedalMetaEvent.type == PedalMetaEvent.Type.PUSH:
						staffDrawable._pedalMetaEvent = null
					else:
						staffDrawable._pedalMetaEvent.type = PedalMetaEvent.Type.PUSH
				"PedalOff":
					if staffDrawable._pedalMetaEvent == null:
						staffDrawable._pedalMetaEvent = PedalMetaEvent.new(PedalMetaEvent.Type.RELEASE)
					elif staffDrawable._pedalMetaEvent.type == PedalMetaEvent.Type.RELEASE:
						staffDrawable._pedalMetaEvent = null
					else:
						staffDrawable._pedalMetaEvent.type = PedalMetaEvent.Type.RELEASE
				"Dynamic":
					if !staffDrawable.has_dynamic_event():
						staffDrawable.add_dynamic_event(DynamicsMetaEvent.new(DynamicsMetaEvent.Type.PPP))
					match staffDrawable.get_dynamic_event().type:
						DynamicsMetaEvent.Type.PPP:
							staffDrawable._dynamicsMetaEvent = DynamicsMetaEvent.new(DynamicsMetaEvent.Type.PP)
						DynamicsMetaEvent.Type.PP:
							staffDrawable._dynamicsMetaEvent = DynamicsMetaEvent.new(DynamicsMetaEvent.Type.P)
						DynamicsMetaEvent.Type.P:
							staffDrawable._dynamicsMetaEvent = DynamicsMetaEvent.new(DynamicsMetaEvent.Type.MP)
						DynamicsMetaEvent.Type.MP:
							staffDrawable._dynamicsMetaEvent = DynamicsMetaEvent.new(DynamicsMetaEvent.Type.MF)
						DynamicsMetaEvent.Type.MF:
							staffDrawable._dynamicsMetaEvent = DynamicsMetaEvent.new(DynamicsMetaEvent.Type.F)
						DynamicsMetaEvent.Type.F:
							staffDrawable._dynamicsMetaEvent = DynamicsMetaEvent.new(DynamicsMetaEvent.Type.FF)
						DynamicsMetaEvent.Type.FF:
							staffDrawable._dynamicsMetaEvent = DynamicsMetaEvent.new(DynamicsMetaEvent.Type.FFF)
						DynamicsMetaEvent.Type.FFF:
							staffDrawable._dynamicsMetaEvent = DynamicsMetaEvent.new(DynamicsMetaEvent.Type.PPP)
			var name_s = self.name.substr(12).split("-")
			print(Melody.tracks[Global.current_viewing_track].bars[name_s[0].to_int()])
			Melody.tracks[Global.current_viewing_track].bars[name_s[0].to_int()].replace_element(xd, name_s[1].to_int())
			self.setup(barline, xd, old_pos)
			print(Melody.tracks[Global.current_viewing_track].bars[name_s[0].to_int()])
			get_parent().reload_stave()
		else:
			if Global.toolbox_element == "Remove":
				remove()
				print("REMOVING")
				return
			print("IM CHANGING... "+str(Global.toolbox_element))
			var name_s = self.name.substr(12).split("-")
			print(Melody.tracks[Global.current_viewing_track].bars[name_s[0].to_int()]._elements[name_s[1].to_int()])
			var xd
			if staffDrawable is Pause:
				xd = staffDrawable as Pause
				if Global.toolbox_element in pause_names:
					match Global.toolbox_element:
						"WholeRest":
							xd._type = Note.Type.WHOLE
						"HalfRest":
							xd._type = Note.Type.HALF
						"QuarterRest":
							xd._type = Note.Type.QUARTER
						"EightRest":
							xd._type = Note.Type.EIGHTH
						"SixteenthRest":
							xd._type = Note.Type.SIXTEENTH
						"ThirtysecondRest":
							xd._type = Note.Type.THIRTYSECOND
			elif staffDrawable is Note:
				xd = staffDrawable as Note
				if Global.toolbox_element in note_names:
					match Global.toolbox_element:
						"WholeNote":
							xd._type = Note.Type.WHOLE
						"HalfNote":
							xd._type = Note.Type.HALF
						"QuarterNote":
							xd._type = Note.Type.QUARTER
						"EightNote":
							xd._type = Note.Type.EIGHTH
						"SixteenthNote":
							xd._type = Note.Type.SIXTEENTH
						"ThirtysecondNote":
							xd._type = Note.Type.THIRTYSECOND
			elif staffDrawable is Accidental:
				xd = staffDrawable as Accidental
				if Global.toolbox_element in accidentals_names:
					match Global.toolbox_element:
						"Sharp":
							xd._type = Accidental.Type.SHARP
						"Natural":
							xd._type = Accidental.Type.NATURAL
						"Flat":
							xd._type = Accidental.Type.FLAT
			print(Melody.tracks[Global.current_viewing_track].bars[name_s[0].to_int()]._elements[name_s[1].to_int()])
			Melody.tracks[Global.current_viewing_track].bars[name_s[0].to_int()].remove_element_at(name_s[1].to_int())
			Melody.tracks[Global.current_viewing_track].bars[name_s[0].to_int()].add_element(xd, name_s[1].to_int())
			print(Global.current_viewing_track)
			self.setup(barline, xd, old_pos)
			get_parent().reload_stave()

func remove():
	var name_s = self.name.substr(12).split("-")
	Melody.tracks[Global.current_viewing_track].bars[name_s[0].to_int()].remove_element_at(name_s[1].to_int())
	if len(Melody.tracks[Global.current_viewing_track].bars[name_s[0].to_int()]._elements) == 0:
		Melody.tracks[Global.current_viewing_track].bars.remove_at(name_s[0].to_int())
	get_parent().reload_stave()
	#get_parent().call_deferred("remove_child", self)
	#self.queue_free()
