class_name EnemyState
extends Node

var enemy : Enemy
var state_machine : EnemyStateMachine

func _ready():
	pass # Replace with function body.

# What happen when we initialize this state
func init() -> void:
	pass
	
# What happen when the enemy enters this state
func enter() -> void:
	pass

# What happen when the enemy exits this state
func exit() -> void:
	pass

# What happen during the _process update in this state
func process( _delta : float ) -> EnemyState:
	return null

# What happen during the _physics_process update in this state
func physics( _delta : float ) -> EnemyState:
	return null
