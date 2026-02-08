class_name State_Carry
extends State

@export var move_speed : float = 100
@export var throw_audio : AudioStream

var walking : bool = false
var throwable : Throwable

@onready var idle : State_Idle = $"../Idle"
@onready var stun : State_Stun = $"../Stun"

func _ready():
	pass # Replace with function body.

# What happen when we initialize this state
func init() -> void:
	pass
	
# What happen when the player enters this state
func enter() -> void:
	walking = false
	player.update_animation( "carry" )
	pass

# What happen when the player exits this state
func exit() -> void:
	if throwable:
		if player.direction == Vector2.ZERO:
			throwable.throw_direction = player.cardinal_direction
		else:
			throwable.throw_direction = player.direction
			
		if state_machine.next_state == stun:
			throwable.throw_direction = throwable.throw_direction.rotated( PI )
			throwable.drop()
			pass
		else:
			player.audio.stream = throw_audio
			player.audio.play()
			throwable.throw()
			pass
		pass
	pass

# What happen during the _process update in this state
func process( _delta : float ) -> State:
	if player.direction == Vector2.ZERO:
		walking = false
		player.update_animation( "carry" )
	elif player.set_direction() or not walking:
		walking = true
		player.update_animation( "carry_walk" )
	
	player.velocity = player.direction * move_speed
	return null

# What happen during the _physics_process update in this state
func physics( _delta : float ) -> State:
	return null

# What happen with input events update in this state	
func handle_input( _event : InputEvent ) -> State:
	if _event.is_action_pressed( "interact" ):
		return idle
	return null
