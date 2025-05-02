extends HBoxContainer
class_name HealthBar

@export var status:Status
@onready var based_bar = $VBoxContainer/Bar/BasedBar

@onready var bar = $VBoxContainer/Bar
@onready var bar_2 = $VBoxContainer/Bar2

func set_status(stat:Status):
	status=stat

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
		
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if status:
		bar.value=move_toward(bar.value,bar.max_value/status.max_health*status.health,50*delta)
		based_bar.value=move_toward(based_bar.value,based_bar.max_value/status.max_health*status.health,25*delta)
		
		bar_2.value=move_toward(bar_2.value,bar_2.max_value/status.max_energy*status.energy,50*delta)
	

	var sc=get_viewport_rect().size.y/648*2.5
	scale=Vector2(sc,sc)
	pass
	
