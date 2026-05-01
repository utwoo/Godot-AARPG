class_name State_Bow
extends State

@onready var idle: State = $"../Idle"

var direction : Vector2 = Vector2.ZERO
var next_state : State = null

const ARROW = preload("uid://ddfutvj84jcg")

# What happen when the player enters this state
func enter() -> void:
	player.update_animation( "bow" )
	player.animation_player.animation_finished.connect( on_animation_finished )
	direction = player.cardinal_direction
	
	var arrow : Node2D = ARROW.instantiate()
	player.add_sibling( arrow )
	arrow.global_position = player.global_position + ( direction * 32 )
	arrow.fire( direction )
	pass
	
# What happen when the player exits this state
func exit() -> void:
	player.animation_player.animation_finished.disconnect( on_animation_finished )
	next_state = null
	pass
	
# What happen during the _process update in this state
func process( _delta : float ) -> State:
	player.velocity = Vector2.ZERO
	return next_state

func on_animation_finished( _animate_name : String):
	next_state = idle
	pass
