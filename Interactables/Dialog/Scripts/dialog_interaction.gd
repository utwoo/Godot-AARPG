@tool
@icon("res://GUI/DialogSystem/icons/chat_bubbles.svg")
class_name DialogInteraction
extends Area2D

signal player_interacted
signal finished

@export var enabled : bool = true

@onready var animation_player = $AnimationPlayer

var dialog_items : Array[ DialogItem ]

func _ready():
	if Engine.is_editor_hint():
		return

	area_entered.connect( _on_area_entered )
	area_exited.connect( _on_area_exited )
	
	for c in get_children():
		if c is DialogItem:
			dialog_items.append( c )
	
	pass

func _on_area_entered( _area : Area2D ):
	if enabled == false || dialog_items.size() == 0:
		return
	animation_player.play("show")
	PlayerManager.interact_pressed.connect( player_interact )
	pass
	
func _on_area_exited( _area : Area2D ):
	animation_player.play("hide")
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass
	
func player_interact():
	player_interacted.emit()
	await get_tree().process_frame
	await get_tree().process_frame
	DialogSystem.show_dialog( dialog_items )
	DialogSystem.finished.connect( _on_dialog_finished )
	pass

func _on_dialog_finished():
	DialogSystem.finished.disconnect( _on_dialog_finished )
	finished.emit()
	pass

func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_dialog_items() == false:
		return [ "Requires at least one dialog node." ]
	else:
		return []

func _check_for_dialog_items() -> bool:
	for c in get_children():
		if c is DialogItem:
			return true
	return false
	
