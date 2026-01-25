@icon("res://GUI/DialogSystem/icons/star_bubble.svg")
class_name DialogSystemNode
extends CanvasLayer

var is_active : bool = false

@onready var dialog_ui : Control = $DialogUI

func _ready():
	hide_dialog()
	pass

func _unhandled_input( event : InputEvent ):
	#if is_active == false:
		#return
	
	if event.is_action("test"):
		show_dialog()
	else:
		hide_dialog()
	pass

func show_dialog():
	is_active = true
	dialog_ui.visible = true
	dialog_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	pass
	
func hide_dialog():
	is_active = false
	dialog_ui.visible = false
	dialog_ui.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	pass
