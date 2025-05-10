extends CanvasLayer
@onready var color_rect: ColorRect = $Panel/ColorRect
@onready var panel: Control = $Panel
@onready var start: Button = $Panel/Panel/Start
@onready var new: Button = $Panel/Panel/New

func _ready() -> void:
	get_window().set_input_as_handled()
	if not FileAccess.file_exists(GameProcesser.DATA_PATH):
		start.disabled=true
	for child in get_children():
		child=child as Button
		if child:
			child.mouse_entered.connect(func():
				child.grab_focus()
			)
	SoundManager.setup_ui_sounds(self)
	new.grab_focus()
	
func hide_title():
	var mati:=color_rect.material as ShaderMaterial
	var tween=create_tween()
	tween.tween_property(mati,"shader_parameter/alpha",0.0,0.2)
	var tween1=create_tween()
	tween1.tween_property(panel,"modulate:a",0.0,0.2)
	await tween.finished
	await tween1.finished
	hide()

func show_title():
	show()
	var mati:=color_rect.material as ShaderMaterial
	var tween=create_tween()
	tween.tween_property(mati,"shader_parameter/alpha",1.0,0.2)
	var tween1=create_tween()
	tween1.tween_property(panel,"modulate:a",1.0,0.2)
	await tween.finished
	await tween1.finished

func _on_start_pressed() -> void:
	GameProcesser.load_data()
	var scene_file:String=GameProcesser.SceneFile[GameProcesser.current_scene]
	GameProcesser.load_game(scene_file)


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_new_pressed() -> void:
	var file=ConfigFile.new()
	file.load(GameProcesser.CONFIG_PATH)
	var introduced=file.get_value("Run","introduced",false)
	if introduced:
		GameProcesser.new_game()
	else:
		GameProcesser.change_scene("res://scenes/tutorial.tscn")


func _on_description_pressed() -> void:
	pass
