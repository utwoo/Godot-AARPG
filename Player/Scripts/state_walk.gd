class_name State_Walk
extends State

@export var move_speed : float = 100.0
@onready var idle : State = $"../Idle"

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
