extends Area2D
class_name SavePoint
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var entering:bool=false
var saved:bool=false

func _process(delta: float) -> void:
	if not saved:
		animation_player.play("idle")
	else:
		animation_player.play("saved")
	var player_pos:=(get_tree().get_first_node_in_group("player") as Player).position
	if (player_pos-position).length()<=25:
		entering=true
	else:
		entering=false
		

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("enter") and entering:
		GameProcesser.save_game()
		saved=true
