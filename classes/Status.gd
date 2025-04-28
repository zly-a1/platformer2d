extends Node

class_name Status

@export var health:int=10
@export var max_health:int=10

@export var energy:float =100
@export var max_energy:float =100



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health>max_health:
		health=max_health
	if energy<max_energy:
		energy+=10*delta
		if energy>max_energy:
			energy=max_energy
