class_name State_Idle
extends State

@onready var walk : State = $"../Walk"
@onready var attack : State = $"../Attack"
@onready var dash: State_Dash = $"../Dash"

# What happen when the player enters this state
func enter() -> void:
	player.update_animation("idle")
	pass

# What happen during the _process update in this state
func process(_delta) -> State:
	if player.direction != Vector2.ZERO:
		return walk
		
	player.velocity = Vector2.ZERO
	return null
	
	# What happen with input events update in this state	
func handle_input( _event : InputEvent ) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	elif _event.is_action_pressed("interact"):
		PlayerManager.interact()
	elif _event.is_action("dash"):
		return dash
	return null
