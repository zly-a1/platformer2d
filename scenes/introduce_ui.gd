extends CanvasLayer
@onready var label: Label = $Label

var introduced:bool=false

var current_line:int
var tween:Tween

const intro_list:Array=[
	"左右箭头键移动",
	"空格键跳跃",
	"J键攻击",
	"K键闪现",
	"M键发射手里剑",
	"Esc键暂停",
	"开始游戏吧！"
]

func _ready() -> void:
	var file=ConfigFile.new()
	file.load(GameProcesser.CONFIG_PATH)
	introduced=file.get_value("Run","introduced",false)
	if not introduced:
		show_line(0)
	else:
		queue_free()
func introduce() -> void:
	pass

func  _input(event: InputEvent) -> void:
	if not introduced:
		if tween.is_running():
			return
		var condition:bool=false
		
		if current_line==0:
			if Input.get_axis("ui_left","ui_right")!=0:
				condition=true
			else:
				get_window().set_input_as_handled()
		if current_line==1:
			if Input.is_action_just_pressed("jump"):
				condition=true
			else:
				get_window().set_input_as_handled()
		if current_line==2:
			if Input.is_action_just_pressed("attack"):
				condition=true
			else:
				get_window().set_input_as_handled()
		if current_line==3:
			if Input.is_action_just_pressed("flash"):
				condition=true
			else:
				get_window().set_input_as_handled()
		if current_line==4:
			if Input.is_action_just_pressed("shoot"):
				condition=true
			else:
				get_window().set_input_as_handled()
		if current_line==5:
			if Input.is_action_just_pressed("ui_cancel"):
				condition=true
			else:
				get_window().set_input_as_handled()
		if current_line==6:
			condition=true
			var file=ConfigFile.new()
			file.load(GameProcesser.CONFIG_PATH)
			file.set_value("Run","introduced",true)
			file.save(GameProcesser.CONFIG_PATH)
		
		if condition:
			if event.is_pressed() and not event.is_echo():
				if current_line + 1 < intro_list.size():
					show_line(current_line + 1)
					condition=false
				else:
					introduced=true
					tween = create_tween()
					tween.tween_property(label,"modulate:a",0.0,0.2)

func show_line(line: int) -> void:
	current_line = line
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	label.visible_characters=0
	
	tween.tween_callback(label.set_text.bind(intro_list[line]))
	tween.tween_property(label, "visible_characters", (intro_list[line] as String).length(), 1)
