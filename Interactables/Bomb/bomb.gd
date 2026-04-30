class_name ThrowableBomb
extends Throwable

@export_category( "Bomb Settings" )
@export_range( 1.0, 10.0, 0.1, "s" ) var fuse_duration : float = 4.0

@export_category( "Bounce Settings" )
@export_range( 0.1, 0.9, 0.05 ) var bounceness : float = 0.5
@export_range( 1, 10, 1 ) var max_bounce : int = 5

var bounce_count : int = 0
var og_throw_speed : float = 0.0

@onready var explosion_sprite: Sprite2D = $"../ExplosionSprite"

func _ready():
	super()
	hurt_box.damage = 0
	animation_player.queue( "explode" )
	animation_player.speed_scale = animation_player.speed_scale / fuse_duration
	animation_player.animation_changed.connect( _on_animation_changed )
	
func _physics_process( delta : float ):
	super( delta )
	explosion_sprite.position = object_sprite.position
	pass

func _on_animation_changed( _old_name : String, _new_string : String ):
	animation_player.speed_scale = 1.0
	pass
	
func hit_ground():
	bounce_count += 1
	
	if bounce_count <= max_bounce:
		object_sprite.position.y = ground_height - 1
		vertical_velocity *= bounceness * -1
		throw_speed *= bounceness
	else:
		set_physics_process( false )
		hurt_box.set_deferred( "monitoring", false )
		hurt_box.did_damage.disconnect( did_damage )
		wall_detect.body_entered.disconnect( _on_body_entered )
		area_entered.disconnect( _on_area_enter )
		area_exited.disconnect( _on_area_exit )
		
func did_damage():
	var throw_magnitude : Vector2 = throw_direction.abs()
	if throw_magnitude.x > throw_magnitude.y:
		throw_direction *= Vector2( -1, 1 )
	else:
		throw_direction *= Vector2( 1, -1 )
	throw_speed *= bounceness
	
func disable_collisions( _node : Node ):
	super( _node )
	$"../HurtBox/CollisionShape2D".disabled = false
	
func drop():
	super()
	if animation_player.current_animation == "explode":
		explosion_sprite.position = object_sprite.position
		set_physics_process( false )
