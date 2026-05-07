class_name State_Grapple
extends State

@onready var idle: State_Idle = $"../Idle"

@onready var grapple_hook: Node2D = $"../../GrappleHook"
@onready var nine_patch_rect: NinePatchRect = $"../../GrappleHook/NinePatchRect"
@onready var chain_audio_player: AudioStreamPlayer2D = $"../../GrappleHook/AudioStreamPlayer2D"
@onready var grapple_ray_cast: RayCast2D = %GrappleRayCast2D
@onready var grapple_hurt_box: HurtBox = $"../../GrappleHook/NinePatchRect/Control/HurtBox"

@export var grapple_distance : float = 100.0
@export var grapple_speed : float = 200

@export_category(" Audio SFX ")
@export var grapple_fire_audio : AudioStream
@export var grapple_stick_audio : AudioStream
@export var grapple_bounce_audio : AudioStream

var collision_distance : float
var collision_type : int = 0 # 0 = none, 1 = wall, 2 = grapple point
var nine_patch_size : float = 25.0

var tween : Tween
var next_state : State = null

var positions : Array[ Vector3 ] = [
	Vector3( 0.0, -20.0, 180.0 ), # UP
	Vector3( 0.0, -10.0, 0.0 ), # DOWN
	Vector3( -10.0, -15.0, 90.0 ), # LEFT
	Vector3( 10.0, -15.0, -90.0 ), # RIGHT
]
var pos_map : Dictionary = {
	Vector2.UP: 0,
	Vector2.DOWN: 1,
	Vector2.LEFT: 2,
	Vector2.RIGHT: 3
}

func _ready():
	pass # Replace with function body.

# What happen when we initialize this state
func init() -> void:
	grapple_hook.hide()
	grapple_ray_cast.enabled = false
	grapple_ray_cast.target_position.y = grapple_distance
	grapple_hurt_box.monitoring = false
	pass
	
# What happen when the player enters this state
func enter() -> void:
	player.update_animation( "idle" )
	grapple_hook.show()
	grapple_hurt_box.monitoring = true
	
	# set grapple hook direction
	set_grapple_direction()
	# raycast detection
	raycast_detection()
	# shoot grapple hook
	shoot_grapple()
	
	chain_audio_player.play()
	# play fire audio
	play_audio( grapple_fire_audio )
	pass

# What happen when the player exits this state
func exit() -> void:
	next_state = null
	grapple_hook.hide()
	chain_audio_player.stop()
	tween.kill()
	nine_patch_rect.size.y = nine_patch_size
	grapple_hurt_box.monitoring = false
	pass

# What happen during the _process update in this state
func process( _delta : float ) -> State:
	player.velocity = Vector2.ZERO
	return next_state
	
func set_grapple_direction():
	var new_pos : Vector3 = positions[ pos_map[ player.cardinal_direction ] ]
	grapple_hook.position = Vector2( new_pos.x, new_pos.y )
	grapple_hook.rotation_degrees = new_pos.z
	if player.cardinal_direction == Vector2.UP:
		grapple_hook.show_behind_parent = true
	else:
		grapple_hook.show_behind_parent = false
	
	pass

func raycast_detection():
	collision_type = 0
	collision_distance = grapple_distance
	
	grapple_ray_cast.set_collision_mask_value( 5, false )
	grapple_ray_cast.set_collision_mask_value( 6, true )
	grapple_ray_cast.force_raycast_update()
	if grapple_ray_cast.is_colliding():
		collision_type = 2
		collision_distance = grapple_ray_cast.get_collision_point().distance_to( player.global_position )
		return
	
	grapple_ray_cast.set_collision_mask_value( 5, true )
	grapple_ray_cast.set_collision_mask_value( 6, false )
	grapple_ray_cast.force_raycast_update()
	if grapple_ray_cast.is_colliding():
		collision_type = 1
		collision_distance = grapple_ray_cast.get_collision_point().distance_to( player.global_position )
		return
		
	pass
	
func shoot_grapple():
	if tween:
		tween.kill()
		
	var tween_duration : float = collision_distance / grapple_speed
	tween = create_tween()
	tween.tween_property(
		nine_patch_rect, "size",
		Vector2( nine_patch_rect.size.x, collision_distance ),
		tween_duration )
		
	if collision_type == 2:
		tween.tween_callback( grapple_player )
	else:
		tween.tween_callback( return_grapple )
	pass
	
func grapple_player():
	if tween:
		tween.kill()
	
	play_audio( grapple_stick_audio )
	
	var tween_duration : float = collision_distance / grapple_speed
	tween = create_tween()
	tween.tween_property(
		nine_patch_rect, "size",
		Vector2( nine_patch_rect.size.x, nine_patch_size ),
		tween_duration )
	
	var player_target = player.global_position
	player_target += player.cardinal_direction * collision_distance
	player_target -= player.cardinal_direction * nine_patch_size
	
	tween.parallel().tween_property(
		player, "global_position",
		player_target,
		tween_duration)
	
	tween.tween_callback( grapple_finished )
	pass


func return_grapple():
	if tween:
		tween.kill()
	
	if collision_type > 0:
		play_audio( grapple_bounce_audio )
		
	var tween_duration : float = collision_distance / grapple_speed
	tween = create_tween()
	tween.tween_property(
		nine_patch_rect, "size",
		Vector2( nine_patch_rect.size.x, nine_patch_size ),
		tween_duration )
	
	tween.tween_callback( grapple_finished )
	pass
	
func grapple_finished():
	next_state = idle
	pass
	
	
func play_audio( audio : AudioStream ):
	player.audio.stream = audio
	player.audio.play()
