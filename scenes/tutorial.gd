extends Node2D

@onready var background = $Background
@onready var map = $map
@onready var camera_2d = $player/PlayerCamera






# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.setup_ui_sounds(self)
	var rect:Rect2=background.get_rect()
	camera_2d.limit_left=rect.position.x
	camera_2d.limit_right=rect.end.x
	camera_2d.limit_top=rect.position.y
	camera_2d.limit_bottom=rect.end.y
	camera_2d.reset_smoothing()
	camera_2d.force_update_scroll()


func _on_introduce_ui_tutorial_finished() -> void:
	await get_tree().create_timer(1.0).timeout
	GameProcesser.new_game()
	pass # Replace with function body.
