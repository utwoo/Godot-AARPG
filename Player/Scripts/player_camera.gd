class_name PlayerCamera extends Camera2D

@export_range(0, 1, 0.05, "or_greater") var shake_power : float = 0.5
@export var shake_max_offset : float = 5.0
@export var shake_decay : float = 1.0 # 震动衰减

var shake_trauma : float = 0.0

func _ready():
	LevelManager.tilemap_bounds_changed.connect( update_limits )
	update_limits( LevelManager.current_tilemap_bounds )
	PlayerManager.camera_shook.connect( add_camera_shake )
	pass

func _physics_process( delta : float ):
	if shake_trauma > 0:
		shake_trauma = max ( shake_trauma - shake_decay * delta, 0 )
		shake()
		pass
	pass


func add_camera_shake( value : float ):
	shake_trauma = value
	pass


func shake():
	var amount : float = pow ( shake_trauma * shake_power, 2 )
	offset = Vector2( randf_range( -1, 1 ), randf_range( -1, 1 ) ) * shake_max_offset * amount
	pass

func update_limits( bounds : Array [Vector2 ] ):
	if bounds == []:
		return
		
	limit_left = int( bounds[0].x )
	limit_top = int( bounds[0].y )
	limit_right = int( bounds[1].x )
	limit_bottom = int( bounds[1].y )
	pass
