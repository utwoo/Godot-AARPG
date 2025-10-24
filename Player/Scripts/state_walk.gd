class_name State_Walk
extends State

@export var move_speed : float = 100.0
@onready var idle : State = $"../Idle"
@onready var attack : State = $"../Attack"

# What happen when the player enters this state
func Enter() -> void:
	player.UpdateAnimation("walk")

# What happen during the _process update in this state
func Process(_delta) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * move_speed
	
	if player.SetDirection():
		player.UpdateAnimation("walk")
	
	return null

func HandleInput( _event : InputEvent ) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
