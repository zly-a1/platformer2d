extends CharacterBody2D
class_name Player

enum State{
	IDLE,
	RUN,
	JUMP,
	FALL,
	WALL_JUMP,
	HURT,
	DYING,
	ATTACK,
	FLASH
}

const STATE_STR:=["IDLE","RUN","JUMP","FALL","WALL_JUMP"]

signal died()

@onready var sprite_2d = $Graphics/Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var coyote = $coyote
@onready var state_machine:StateMachine = $StateMachine
@onready var super_time = $SuperTime
@onready var graphics = $Graphics
@onready var status:Status = $Status
@onready var hitter = $Graphics/Hitter


@onready var hurter = $Graphics/Hurter
@onready var joy_pad: Control = $foreUI/JoyPad
@onready var status_bar: = $foreUI/StatusPanel
@onready var pausepanel: PausePanel = $foreUI/pausepanel
@onready var game_over_panel: Control = $foreUI/GameOverPanel







enum Direction{
	LEFT=-1,
	RIGHT=+1
}

@export var direction:=Direction.RIGHT:
	set(v):
		direction=v
		if not is_node_ready():
			await ready
		graphics.scale.x=direction

const GROUND_STATES :=[State.IDLE,State.RUN]
const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const GROUND_ACCELERATIION = 1500
const AIR_ACCELERATION = 2000
const FLASH_SPEED=750

var gravity =900
var damage:bool = false
var energy_delta:float=0


func tick_physics(state:State,delta:float)->void:
	if state!=State.DYING:
		graphics.modulate.r=1
		graphics.modulate.g=1
		graphics.modulate.b=1
		if not super_time.is_stopped():
			graphics.modulate.a=sin(Time.get_ticks_msec()/40)*0.5+0.5
				
	
	
	match state:
		State.IDLE:
			
			move(gravity,delta)
			
		State.RUN:
			
			move(gravity,delta)
			
		State.JUMP:
			
		
			move(gravity,delta)
			
		State.FALL:
		
			move(gravity,delta)
		State.WALL_JUMP:
			
			velocity.y=gravity*delta*4
			move(0,delta)
		State.HURT:
			
			move(gravity,delta)
		State.DYING:
			velocity.x=0
			velocity.y=0
			move(0.0,delta)
		State.ATTACK:
			move(gravity,delta)
		State.FLASH:
			
			velocity.y=0
			move(0.0,delta)
	


func move(vy:float,delta:float):
	
	var dire=Input.get_axis("ui_left","ui_right") if state_machine.current_state!=State.FLASH else direction
	var acceleration: =GROUND_ACCELERATIION if is_on_floor() else AIR_ACCELERATION
	velocity.y += vy * delta
	velocity.x=move_toward(velocity.x,dire*SPEED,acceleration*delta) if state_machine.current_state!=State.DYING else 0.0
	
	if not is_zero_approx(dire):
		direction=Direction.LEFT if dire<0 else Direction.RIGHT
	
	
	move_and_slide()
	
		



func get_next_state(state:State) ->State:
	if status.health<=0:
		return State.DYING
	
	var can_jump:bool=is_on_floor() or (coyote.time_left > 0)
	var should_jump=can_jump and Input.is_action_just_pressed("jump")
	
	
	
	
	var direction: = Input.get_axis("ui_left","ui_right")
	var is_still= is_zero_approx(direction) and is_zero_approx(velocity.x)
	match state:
		State.IDLE:
			if not is_on_floor():
				return State.FALL
			if not is_still:
				return State.RUN
			
		State.RUN:
			var pl:=SoundManager.sfx.get_node("Walk") as AudioStreamPlayer
			if pl and  not pl.playing:
				SoundManager.play_sfx("Walk")
			if not is_on_floor():
				return State.FALL
			if is_still:
				return State.IDLE
			
		State.JUMP:
			if is_on_wall_only() and velocity.y>0:
				return State.WALL_JUMP
			if velocity.y>0:
				return State.FALL
				
			
		State.FALL:
			if is_on_wall_only():
				return State.WALL_JUMP
			if is_on_floor():                                     
				return State.IDLE if is_still else State.RUN
			
		State.WALL_JUMP:
			if Input.is_action_just_pressed("jump"):
				return State.JUMP
			if not is_on_wall_only():
				if is_on_floor():
					return State.IDLE
				else:
					return State.FALL
			
		State.HURT:
			damage=false
			if not animation_player.is_playing():
				return State.IDLE
		State.DYING:
			pass
		State.ATTACK:
			if not animation_player.is_playing():
				hitter.monitoring=false
				return State.IDLE
		State.FLASH:
			hurter.monitorable=false
			if not animation_player.is_playing() or is_on_wall():
				
				graphics.modulate=Color(1,1,1,1)
				$Graphics/Hurter/CollisionShape2D.disabled=false
				velocity.x=0
				hurter.monitorable=true
				return State.IDLE
	
	if damage:
		if hitter.monitoring:
			hitter.monitoring=false
		return State.HURT
	if should_jump:
		return State.JUMP
	if super_time.is_stopped():
		hurter.monitorable=true
	
	if Input.is_action_just_pressed("attack"):
		hitter.monitoring=true
		return State.ATTACK
	if Input.is_action_just_pressed("flash") and status.energy>=30 and not is_on_wall():
		return State.FLASH
	return state

func change_state(from:State,to:State)->void:
	print("[%s]:%s->%s"%[Engine.get_physics_frames(),State.keys()[from]if from!=-1 else "START",State.keys()[to]])
	if from in GROUND_STATES and to in GROUND_STATES:
		coyote.stop()
	match to:
		State.IDLE:
			animation_player.play("idle")
			
		State.RUN:
			animation_player.play("run")
			
		State.JUMP:
			
			animation_player.play("jump")
			SoundManager.play_sfx("Jump")
			if from==State.WALL_JUMP:
				direction*=-1
				velocity.x=direction*550.0
			velocity.y = JUMP_VELOCITY
			coyote.stop()
			
		State.FALL:
			animation_player.play("fall")
			if from in GROUND_STATES:
				coyote.start()
		State.WALL_JUMP:
			animation_player.play("walljump")
			direction=-get_wall_normal().x as int
			
		State.HURT:
			damage=true
			animation_player.play("hurt")
			SoundManager.play_sfx("Hurt")
			GameProcesser.shake_camera(5.0)
		State.DYING:
			animation_player.play("dying")
			GameProcesser.shake_camera(5.0)
		State.ATTACK:
			animation_player.play("attack")
			SoundManager.play_sfx("Attack")
		State.FLASH:
			energy_delta=status.energy
			status.energy-=30
			if status.energy<0:
				status.energy=0
			energy_delta-=status.energy
			animation_player.play("flash")
			SoundManager.play_sfx("Flash")
	pass

func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("shoot") and status.energy>=10 and state_machine.current_state!=State.WALL_JUMP:
		shoot()
	if event.is_action_pressed("ui_cancel") and pausepanel.can_show:
		pausepanel.show_panel()
	



func _on_hurter_hurt(hitter):
	if not super_time.is_stopped():
		return
	if status.health>0:
		status.health-=1
		damage=true
		super_time.start()
		var hit_ter:CharacterBody2D=hitter.owner
		velocity=(-velocity).normalized()*700.0 if not(is_zero_approx(velocity.x) and is_zero_approx(velocity.x)) else (position-hit_ter.position).normalized()*700.0
		
func die():
	died.emit()
	game_over_panel.show_panel()
	set_process(false)


func _on_spike_entered(body):
	if not body is Enemy and super_time.is_stopped():
		if status.health>0:
			status.health-=1
		damage=true
		super_time.start()
		var hit_ter:Node2D=body
		velocity=(-velocity).normalized()*700.0 if not(is_zero_approx(velocity.x) and is_zero_approx(velocity.x)) else (position-hit_ter.position).normalized()*700.0

func shoot():
	var ene_sub:=move_toward(status.energy,0.0,10)
	if ene_sub<=0:
		return
	status.energy=ene_sub
	var bullet:=preload("res://scenes/bullet.tscn").instantiate()
		
	bullet.velocity.x=direction*bullet.SPEED
	bullet.position=position
		
	get_parent().add_child(bullet,true)
	SoundManager.play_sfx("Slash")

func flash_start():
	velocity.x=direction*FLASH_SPEED

func flash_stop():
	velocity.x=0

func _ready() -> void:
	$Graphics/Hurter/CollisionShape2D.disabled=false

func _on_super_time_timeout() -> void:
	graphics.modulate.a=1
	$Graphics/Hurter/CollisionShape2D.disabled=false
	pass # Replace with function body.
