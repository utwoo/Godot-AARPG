class_name PlayAbilities
extends Node

const BOOMERANG = preload("res://Player/Scenes/boomerang.tscn")

enum abilities { BOOMERANG }

var selected_ability = abilities.BOOMERANG
var player : Player
var boomerang_instance : Boomerang = null

func _ready():
	player = PlayerManager.player
	pass

func _unhandled_input( event : InputEvent ):
	if event.is_action_pressed("ability"):
		if selected_ability == abilities.BOOMERANG:
			boomerang_ability()
	pass
	
func boomerang_ability():
	if boomerang_instance != null:
		return

	var _b : Boomerang = BOOMERANG.instantiate() as Boomerang
	player.add_sibling( _b )
	_b.global_position = player.global_position
	
	var throw_direction = player.direction
	if throw_direction == Vector2.ZERO:
		throw_direction = player.cardinal_direction
	_b.throw( throw_direction )
	
	boomerang_instance = _b
	pass
