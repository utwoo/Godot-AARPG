@tool
class_name LevelTransitionInteract
extends LevelTransition

func _ready():
	super()
	area_entered.connect( on_area_entered )
	area_exited.connect( on_area_exited )

func player_interact():
	_player_entered( PlayerManager.player )
	pass

func on_area_entered( _area : Area2D ):
	PlayerManager.interact_pressed.connect( player_interact )
	pass
	
func on_area_exited( _area : Area2D ):
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass
