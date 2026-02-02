@tool
@icon("res://GUI/DialogSystem/icons/answer_bubble.svg")
class_name DialogBranch
extends DialogItem

@export var text : String = "ok..." : set = _set_text

var dialog_items : Array[ DialogItem ]

func _ready():
	super()
	
	if Engine.is_editor_hint():
		return
	
	for c in get_children():
		if c is DialogItem:
			dialog_items.append( c )
	
	pass

func _set_editor_display() -> void:
	var p = get_parent()
	if p is DialogChoice:
		set_related_text()
		if p.dialog_branches.size() < 2:
			return
		
		example_dialog.set_dialog_choice( p as DialogChoice )
	pass
	
func set_related_text():
	var p = get_parent()
	var p2 = p.get_parent()
	var t = p2.get_child( p.get_index() - 1 )
	
	if t is DialogText:
		example_dialog.set_dialog_text( t )
		example_dialog.content.visible_ratio = 1

	pass
	

func _set_text( value : String ):
	text = value
	if Engine.is_editor_hint():
		if example_dialog != null:
			_set_editor_display()
