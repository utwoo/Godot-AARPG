class_name State
extends Node

static var player : Player

func _ready():
	pass # Replace with function body.

# What happen when the player enters this state
func Enter() -> void:
	pass

# What happen when the player exits this state
func Exit() -> void:
	pass

# What happen during the _process update in this state
func Process( _delta : float ) -> State:
	return null

# What happen during the _physics_process update in this state
func Physics( _delta : float ) -> State:
	return null

# What happen with input events update in this state	
func HandleInput( _event : InputEvent ) -> State:
	return null
