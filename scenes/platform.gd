extends CharacterBody2D
class_name Platform
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

const SPEED=100.0
@export var v:Vector2

func set_stats(velocity:Vector2,pos:Vector2):
	global_position=pos
	v=velocity
	

func _physics_process(delta: float) -> void:
	animation_player.play("idle")
	global_position+=v*delta

func _process(delta: float) -> void:
	pass
func _on_ground_entered(body: Node2D) -> void:
	if body is TileMap:
		v*=-1
