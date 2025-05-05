extends World

@onready var label: Label = $Label

var introduced:bool=false

var intro_list:Array=[
	"左右箭头键移动",
	"空格键跳跃",
	"J键攻击",
	"K键闪现",
	"M键发射手里剑",
	"Esc键暂停",
	"开始游戏吧！"
]

func _ready() -> void:
	GameProcesser.fix_camera.connect(func():
		camera_2d.reset_smoothing()
		camera_2d.force_update_scroll()
		)
	var tilesize=map.tile_set.tile_size.x
	var mappos=map.get_used_rect().position*tilesize
	var mapsize=map.get_used_rect().size*tilesize
	background.size=mapsize+Vector2i(400,400)
	background.position=mappos-Vector2i(200,200)
	camera_2d.limit_left=mappos.x
	camera_2d.limit_top=mappos.y-400
	camera_2d.limit_right=mappos.x+mapsize.x
	camera_2d.limit_bottom=mappos.y+mapsize.y
	SoundManager.setup_ui_sounds(self)
	player.status.health=GameProcesser.player_status.health
	player.status.energy=GameProcesser.player_status.energy
	
	introduced=false

func introduce() -> void:
	#if not introduced:
		#var i=0
		#for intro in intro_list:
			#label.text=intro_list[i]
			#label.visible_characters=0
			#$AnimationPlayer.play("show")
			#await not $AnimationPlayer.is_playing()
			#
			#await get_tree().create_timer(2.0).timeout
			#i+=1
		#var tween1=create_tween()
		#tween1.tween_property(label,"modulate:a",0.0,0.5)
		#await tween1.finished
		#introduced=true
			#
			#
	pass

func  _input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		introduce()
