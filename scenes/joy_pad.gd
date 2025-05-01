extends Control
@onready var back: Sprite2D = $Control2/Back
@onready var fore: Sprite2D = $Control2/Fore
@onready var control_2: Control = $Control2

@onready var vec_pos:Vector2=back.position

var fg_idx:int=-1
var finger_offset:Vector2

func _ready() -> void:
	#$Control.scale=get_viewport().size/1024
	#$Control2.scale=get_viewport().size/1024
	#$Control4.scale=get_viewport().size/1024
	pass

func _input(event: InputEvent) -> void:
	var sd=event as InputEventScreenDrag
	if sd and sd.index==fg_idx:
		finger_offset=sd.position*back.get_global_transform()
		if not back.get_rect().has_point(back.to_local(sd.position)):
			fore.position=finger_offset.limit_length(64)+vec_pos
		else:
			fore.position=sd.position*control_2.get_global_transform()
		
		
		if finger_offset.x > 0:
			Input.action_release("ui_left")
			Input.action_press("ui_right", finger_offset.x/16)
		elif finger_offset.x < 0:
			Input.action_release("ui_right")
			Input.action_press("ui_left", -finger_offset.x/16)
		
	
	var st=event as InputEventScreenTouch
	if st:
		if st.pressed and fg_idx==-1 and (st.position*back.get_global_transform()).length()<=2400:
			fg_idx=st.index
		if not st.pressed and st.index==fg_idx:
			fore.position=vec_pos
			fg_idx=-1
			Input.action_release("ui_left")
			Input.action_release("ui_right")
