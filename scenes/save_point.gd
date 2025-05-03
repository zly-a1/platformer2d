extends Area2D
class_name SavePoint
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal enter()
signal exit()

var entering:bool=false
var saved:bool=false

func _process(delta: float) -> void:
	if not saved:
		animation_player.play("idle")
	else:
		animation_player.play("saved")
		

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("enter") and entering:
		GameProcesser.save_game()
		saved=true




func _on_player_entered(body: Node2D) -> void:
	if body is Player:
		entering=true
		enter.emit()
	pass # Replace with function body.


func _on_player_exited(body: Node2D) -> void:
	if body is Player:
		entering=false
		exit.emit()
	pass # Replace with function body.
