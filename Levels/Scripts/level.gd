class_name Level 
extends Node2D

@export var music : AudioStream

func _ready():
	self.y_sort_enabled = true
	PlayerManager.set_as_parent( self )
	LevelManager.level_load_started.connect( _free_level )
	AudioManager.play_music( music )

func _free_level():
	PlayerManager._unparent_player( self )
	queue_free()
