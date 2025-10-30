class_name State
extends Node

static var player : Player

func _ready():
	pass # Replace with function body.

# What happen when the player enters this state
func enter() -> void:
	pass

# What happen when the player exits this state
func exit() -> void:
	pass

# What happen during the _process update in this state
func process( _delta : float ) -> State:
	return null

# What happen during the _physics_process update in this state
func physics( _delta : float ) -> State:
	return null

# What happen with input events update in this state	
func handle_input( _event : InputEvent ) -> State:
	return null
