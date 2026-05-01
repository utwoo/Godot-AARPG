class_name State_Lift
extends State

@export var lift_audio : AudioStream

@onready var carry = $"../Carry"

var animation_seek = 0

# What happen when we initialize this state
func init() -> void:
	pass
	
# What happen when the player enters this state
func enter() -> void:
	player.update_animation( "lift" )
	if animation_seek != 0:
		player.animation_player.seek( animation_seek )
	player.animation_player.animation_finished.connect( state_complete )
	player.audio.stream = lift_audio
	player.audio.play()
	pass

# What happen when the player exits this state
func exit() -> void:
	animation_seek = 0
	pass

# What happen during the _process update in this state
func process( _delta : float ) -> State:
	return null

# What happen during the _physics_process update in this state
func physics( _delta : float ) -> State:
	player.velocity = Vector2.ZERO
	return null

# What happen with input events update in this state	
func handle_input( _event : InputEvent ) -> State:
	return null
	
func state_complete( _name : String ):
	player.animation_player.animation_finished.disconnect( state_complete )
	state_machine.change_state( carry )
	pass
