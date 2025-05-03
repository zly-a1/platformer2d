extends Control


func _ready() -> void:
	if not OS.get_name()=="Android":
		$Control2/TextureRect.hide()
	$Control4/TouchScreenButton7.hide()
	for portal:Portal in get_tree().get_nodes_in_group("portals"):
		portal.enter.connect(func():
			$Control4/TouchScreenButton7.show()
			)
		portal.exit.connect(func():
			$Control4/TouchScreenButton7.hide()
			)
	for save_point:SavePoint in get_tree().get_nodes_in_group("save_points"):
		save_point.enter.connect(func():
			$Control4/TouchScreenButton7.show()
			)
		save_point.exit.connect(func():
			$Control4/TouchScreenButton7.hide()
			)
	for child:TouchScreenButton in $Control4.get_children():
		child.pressed.connect(func():
			child.modulate.a=0.5
			)
		child.released.connect(func():
			child.modulate.a=1
			)

func _process(delta:float) -> void:
	var sc=Vector2(get_viewport().size.y/$Control2/TextureRect.size.y,get_viewport().size.y/$Control2/TextureRect.size.y)
	for child:Control in get_children():
		child.scale=sc/4
	pass
