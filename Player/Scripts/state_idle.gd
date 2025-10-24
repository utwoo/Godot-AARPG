class_name State_Idle
extends State

@onready var walk = $"../Walk"

# What happen when the player enters this state
func Enter() -> void:
	player.UpdateAnimation("idle")

# What happen during the _process update in this state
func Process(_delta) -> State:
	if player.direction != Vector2.ZERO:
		return walk
		
	player.velocity = Vector2.ZERO
	return null
