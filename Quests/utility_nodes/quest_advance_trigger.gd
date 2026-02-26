@tool
@icon("res://Quests/utility_nodes/icons/quest_advance.png")
class_name QuestAdvanceTrigger
extends QuestNode

signal advanced

func _ready():
	if Engine.is_editor_hint():
		return
	
	$Sprite2D.queue_free()
	pass
	
func advance_quest():
	if linked_quest == null:
		return
		
	await get_tree().process_frame
	
	advanced.emit()
	
	var _title : String = linked_quest.title
	var _step : String = get_step()
	
	if _step == "N/A":
		_step = ""

	QuestManager.update_quest( _title, _step, quest_complete )
	pass
