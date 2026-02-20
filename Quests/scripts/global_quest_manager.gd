extends Node

signal quest_updated( quest : Dictionary )

const QUEST_DATA_LOCATION : String = "res://Quests/"

var quests : Array[ Quest ]
var current_quests : Array # { title = "not found", is_complete = false, complete_steps = [''] }


func _ready():
	# Gather all quests
	gather_quest_data()
	pass
	

func _unhandled_input( event : InputEvent ):
	if event.is_action("test"):
		print("quest test")
	pass
	

func gather_quest_data():
	quests.clear()
	
	# Gather all quest resources and add to quests array
	var quest_files : PackedStringArray = DirAccess.get_files_at( QUEST_DATA_LOCATION )
	for q in quest_files:
		quests.append( load( QUEST_DATA_LOCATION + "/" + q ) as Quest )
		pass
	
	pass
	
# Update the status of a quest
func update_quest( _title : String, _completed_step : String = "", _is_complete : bool = false ):
	var _quest_index : int = get_quest_index_by_title( _title )
	if _quest_index == -1:
		var new_quest : Dictionary = { 
			title = "not found", 
			is_complete = _is_complete, 
			complete_steps = [] 
		}
		
		if _completed_step != "":
			new_quest.complete_steps.append( _completed_step )
			
		current_quests.append( new_quest )
		quest_updated.emit( new_quest )
	else:
		var q = current_quests[ _quest_index ]
		if _completed_step != "" and q.completed_steps.has( _completed_step ) == false:
			q.completed_steps.append( _completed_step )
		q.is_complete = _is_complete
		quest_updated.emit( q )
		
		if q.is_complete:
			disperse_quest_rewards( find_quest_by_title( _title ) )
	pass
	
# Give XP and item rewards to player
func disperse_quest_rewards( _q : Quest ):
	PlayerManager.reward_xp( _q.reward_xp )
	for i in _q.reward_items:
		PlayerManager.INVENTORY_DATA.add_item( i.item, i.quantity )
	pass
	
# Provide a quest and return the current quest associate with it
func find_quest( _quest : Quest ) -> Dictionary:
	for q in current_quests:
		if q.title.to_lower() ==_quest.title.to_lower():
			return q
	return { title = "not found", is_complete = false, complete_steps = [''] }
	
# Take title and find associated quest resource
func find_quest_by_title( _title : String ) -> Quest:
	for q in quests:
		if q.title.to_lower() == _title.to_lower():
			return q
	return null

# Find quest by title name and return index in quest array
func get_quest_index_by_title( _title : String ) -> int:
	for i in current_quests.size():
		if current_quests[ i ].title.to_lower() == _title.to_lower():
			return i
	return -1
	
	
func sort_quests():
	pass
