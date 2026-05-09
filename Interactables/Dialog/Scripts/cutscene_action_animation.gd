@tool
@icon("res://GUI/DialogSystem/icons/cutscene_animation.svg")
class_name CutsceneActionAnimation
extends CutsceneAction

@export var amination_player: AnimationPlayer
@export var amination_name : String

func play():
	if amination_player:
		if amination_name:
			amination_player.process_mode = Node.PROCESS_MODE_ALWAYS
			amination_player.play( amination_name )
			await amination_player.animation_finished
	finished.emit()
	pass
	
