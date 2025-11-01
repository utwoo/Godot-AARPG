class_name EnemyStateDestroy
extends EnemyState

@export var anim_name: String = "destroy"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0

var _direction : Vector2

# What happen when we initialize this state
func init() -> void:
	enemy.enemy_destroy.connect( _on_enemy_destroy )
	pass
	
# What happen when the enemy enters this state
func enter() -> void:
	enemy.invulnerable = true
	
	_direction = enemy.global_position.direction_to( enemy.player.global_position )

	enemy.set_direction( _direction )
	enemy.velocity = _direction * -knockback_speed
	
	enemy.update_animation( anim_name )
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	pass

# What happen when the enemy exits this state
func exit() -> void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect( _on_animation_finished )
	pass

# What happen during the _process update in this state
func process( _delta : float ) -> EnemyState:	
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

# What happen during the _physics_process update in this state
func physics( _delta : float ) -> EnemyState:
	return null
	
func _on_enemy_destroy():
	state_machine.change_state( self )

func _on_animation_finished( _anim : String ):
	enemy.queue_free()
