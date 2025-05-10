extends CanvasLayer

@onready var label: Label = $Label
@onready var player: CharacterBody2D = $"../player"

var introduced: bool = false
var current_line: int = 0
var tween: Tween

signal tutorial_finished

const intro_list: Array = [
	"左右箭头键移动",
	"空格键跳跃",
	"J键攻击",
	"K键闪现",
	"M键发射手里剑",
	"Esc键暂停",
	"开始游戏吧！"
]

func _ready() -> void:
	var file = ConfigFile.new()
	file.load(GameProcesser.CONFIG_PATH)
	introduced = file.get_value("Run", "introduced", false)

	if not introduced:
		show_line(current_line)
	else:
		queue_free()

func _input(event: InputEvent) -> void:
	if introduced or tween.is_running():
		return

	var condition: bool = false

	match current_line:
		0: condition = Input.get_axis("ui_left", "ui_right") != 0
		1: condition = Input.is_action_just_pressed("jump")
		2: condition = Input.is_action_just_pressed("attack")
		3: condition = Input.is_action_just_pressed("flash")
		4: condition = Input.is_action_just_pressed("shoot")
		5: condition = Input.is_action_just_pressed("ui_cancel")
		6: condition = true

	if condition:
		handle_input(event)

func handle_input(event: InputEvent) -> void:
	if event.is_pressed() and not event.is_echo() or current_line==6:
		if current_line < intro_list.size() - 1:
			update_player_key_map()
			show_line(current_line + 1)
		else:
			finish_tutorial()

func update_player_key_map() -> void:
	match current_line:
		0: player.key_map["jump"] = true
		1: player.key_map["attack"] = true
		2: player.key_map["flash"] = true
		3: player.key_map["shoot"] = true
		4: player.key_map["esc"] = true

func finish_tutorial() -> void:
	introduced = true
	var file = ConfigFile.new()
	file.load(GameProcesser.CONFIG_PATH)
	file.set_value("Run", "introduced", true)
	file.save(GameProcesser.CONFIG_PATH)

	tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 0.2)
	tutorial_finished.emit()

func show_line(line: int) -> void:
	current_line = line

	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	label.visible_characters = 0

	tween.tween_callback(label.set_text.bind(intro_list[line]))
	tween.tween_property(label, "visible_characters", (intro_list[line] as String).length(), 1)
