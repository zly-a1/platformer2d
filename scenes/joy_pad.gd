extends Control


var fg_idx:int=-1
var finger_offset:Vector2

func _process(delta:float) -> void:
	var sc=get_viewport_rect().size.y/648
	$Control.scale=Vector2(sc,sc)
	$Control2.scale=Vector2(sc,sc)
	$Control4.scale=Vector2(sc,sc)
	pass
