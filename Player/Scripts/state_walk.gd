class_name State_Walk
extends State

@export var move_speed : float = 100.0
@onready var idle : State = $"../Idle"
@onready var attack : State = $"../Attack"

# What happen when the player enters this state
func enter() -> void:
	player.update_animation("walk")
	pass

# What happen during the _process update in this state
func process(_delta) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * move_speed
	
	if player.set_direction():
		player.update_animation("walk")
	
	return null

func handle_input( _event : InputEvent ) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("interact"):
		PlayerManager._interact_pressed()
	return null
