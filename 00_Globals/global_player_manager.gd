extends Node

const PLAYER = preload("uid://cnuj66g5vdefk")
const INVENTORY_DATA : InventoryData = preload("uid://c41040a0souiw")

signal camera_shook( trauma : float )
signal interact_pressed
signal player_level_up

var interact_handled : bool = true
var player : Player
var player_spawned : bool = false

var level_requirements = [ 0, 20, 50, 100, 200, 400, 800, 1500, 3000, 6000, 12000, 25000 ]
  
func _ready():
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true

func add_player_instance():
	player = PLAYER.instantiate()
	add_child( player )
	pass

func set_player_health( _hp : int, _max_hp : int ):
	player.max_hp = _max_hp
	player.hp = _hp
	player.update_hp( 0 )
	pass
	
func set_player_stats( _level : int, _xp : int, _attack : int, _defense : int):
	player.level = _level
	player.xp = _xp
	player.attack = _attack
	player.defense = _defense
	pass
	
func reward_xp( _xp : int ):
	player.xp += _xp
	check_level_up()
	pass
	

func check_level_up():
	if player.level >= level_requirements.size():
		return
	
	if player.xp >= level_requirements[ player.level ]:
		player.level += 1
		player.attack += 1
		player.defense += 1
		player_level_up.emit()
		check_level_up()
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
	
func interact():
	interact_handled = false
	interact_pressed.emit()
	
func shake_camera( trauma : float = 1 ):
	camera_shook.emit( clampf( trauma, 0, 3 ) )
