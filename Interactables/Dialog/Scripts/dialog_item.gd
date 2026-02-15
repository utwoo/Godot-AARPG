@tool
@icon("res://GUI/DialogSystem/icons/chat_bubble.svg")
class_name DialogItem
extends Node

@export var npc_info : NPCResource

var editor_selection
var example_dialog : DialogSystemNode

func _ready():
	if Engine.is_editor_hint():
		editor_selection = Engine.get_singleton( "EditorInterface" )
		editor_selection.selection_changed.connect( _on_selecton_changed )
		return
	
	check_npc_data()

func check_npc_data():
	if npc_info == null:
		var p = self
		var _checking : bool = true
		while _checking == true:
			p = p.get_parent()
			if p:
				if p is NPC and p.npc_resource:
					npc_info  = p.npc_resource
					_checking = false 
			else:
				_checking = false

func _on_selecton_changed():
	if editor_selection == null:
		return
	
	var selection = editor_selection.get_selected_nodes()
	
	if example_dialog != null:
		example_dialog.queue_free()
	
	if not selection.is_empty():
		if self == selection[ 0 ]:
			example_dialog = load("res://GUI/DialogSystem/dialog_system.tscn").instantiate() as DialogSystemNode
			if example_dialog == null:
				return
			self.add_child( example_dialog )
			
			example_dialog.offset = get_parent_global_position() + Vector2( 32, -200 )
			check_npc_data()
			_set_editor_display()
	
	pass
	
func get_parent_global_position():
	var p = self
	var _checking : bool = true
	while _checking == true:
		p = p.get_parent()
		if p:
			if p is Node2D:
				return p.global_position
		else:
			_checking =false
			
	return Vector2.ZERO
	
func _set_editor_display() -> void:
	pass
