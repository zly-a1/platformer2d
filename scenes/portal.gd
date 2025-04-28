extends Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var entering:bool=false
@export var target_world:String

func _process(delta: float) -> void:
	animation_player.play("shine")
	var player_pos:=(get_tree().get_first_node_in_group("player") as Player).position
	if (player_pos-position).length()<=25:
		entering=true
	else:
		entering=false
		

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("enter") and entering:
		GameProcesser.load_game(target_world)
