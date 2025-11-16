extends Node

const PLAYER = preload("uid://cnuj66g5vdefk")

var player : Player
var player_spawned : bool = false
  
func _ready():
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true

func add_player_instance():
	player = PLAYER.instantiate()
	add_child( player )
	pass
	
func set_player_position( _new_position : Vector2 ):
	player.global_position = _new_position
	pass
	
func set_as_parent( p : Node2D ):
	if player.get_parent():
		player.get_parent().remove_child( player )
	
	p.add_child( player )

func _unparent_player( _p : Node2D ):
	_p.remove_child( player )
