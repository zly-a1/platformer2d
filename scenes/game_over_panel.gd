extends Control

@onready var animation_player = $AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _init():
	modulate.a=0
	

func _input(event):
	if not visible:
		return
	get_window().set_input_as_handled()
	if animation_player.is_playing():
		return
	
	if(event is InputEventKey or 
	   event is InputEventMouse or 
	   event is InputEventScreenTouch
	):
		if event.is_pressed() and not event.is_echo():
			GameProcesser.reload_game()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_panel():
	show()
	#get_tree().paused=true
	animation_player.play("show")
