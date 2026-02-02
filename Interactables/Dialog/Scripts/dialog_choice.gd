@tool
@icon("res://GUI/DialogSystem/icons/question_bubble.svg")
class_name DialogChoice
extends DialogItem

var dialog_branches : Array[ DialogBranch ]

func _ready():
	super()
	for c in get_children():
		if c is DialogBranch:
			dialog_branches.append( c )

func _set_editor_display() -> void:
	set_related_text()
	
	if dialog_branches.size() < 2:
		return
	
	example_dialog.set_dialog_choice( self )
	
	pass
	

func set_related_text():
	var p = get_parent()
	var t = p.get_child( self.get_index() - 1 )
	
	if t is DialogText:
		example_dialog.set_dialog_text( t )
		example_dialog.content.visible_ratio = 1

	pass

func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_dialog_items() == false:
		return [ "Requires at least 2 dialog branch node." ]
	else:
		return []
		
func _check_for_dialog_items() -> bool:
	var _count : int = 0
	for c in get_children():
		if c is DialogBranch:
			_count += 1
			if _count > 1:
				return true
	return false
