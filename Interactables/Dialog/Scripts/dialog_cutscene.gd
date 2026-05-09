@tool
@icon("res://GUI/DialogSystem/icons/cutscene_bubble.svg")
class_name DialogCutscene
extends DialogItem

signal finished

enum Mode { PARALLEL, SEQUENTIAL }
@export var playback_mode : Mode = Mode.SEQUENTIAL

var actions : Array[ CutsceneAction ] = []
var actions_finished_count : int = 0

func _ready():
	gather_actions()
	pass

func play():
	if Engine.is_editor_hint():
		return
	
	actions_finished_count = 0
	
	if actions.is_empty():
		await get_tree().physics_frame
		finished.emit()
	elif playback_mode == Mode.SEQUENTIAL:
		actions[ 0 ].play()
	else:
		for action in actions:
			action.play()
	pass
	

func gather_actions():
	for action in get_children():
		if action is CutsceneAction:
			actions.append( action )
			if not Engine.is_editor_hint():
				action.finished.connect( _on_action_finished )
	pass

func _on_action_finished():
	actions_finished_count += 1
	if actions_finished_count >= actions.size():
		finished.emit()
	elif playback_mode == Mode.SEQUENTIAL:
		actions[ actions_finished_count ].play()
	pass
	
