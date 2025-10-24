class_name State_Idle
extends State

@onready var walk : State = $"../Walk"
@onready var attack : State = $"../Attack"

# What happen when the player enters this state
func Enter() -> void:
	player.UpdateAnimation("idle")

# What happen during the _process update in this state
func Process(_delta) -> State:
	if player.direction != Vector2.ZERO:
		return walk
		
	player.velocity = Vector2.ZERO
	return null
	
	# What happen with input events update in this state	
func HandleInput( _event : InputEvent ) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
