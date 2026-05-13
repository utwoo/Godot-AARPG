class_name State_Cutscene
extends State

@onready var idle: State_Idle = $"../Idle"

# What happen when we initialize this state
func init() -> void:
	DialogSystem.started.connect( _on_dialog_started )
	DialogSystem.finished.connect( _on_dialog_finished )
	pass
	
# What happen when the player enters this state
func enter() -> void:
	player.update_animation("idle")
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	pass

# What happen during the _process update in this state
func process(_delta) -> State:
	player.velocity = Vector2.ZERO
	return null

# What happen when the player exits this state
func exit() -> void:
	player.process_mode = Node.PROCESS_MODE_INHERIT
	pass


func _on_dialog_started():
	state_machine.change_state( self )
	pass


func _on_dialog_finished():
	state_machine.change_state( idle )
	pass
