class_name PlayAbilities
extends Node

const BOOMERANG = preload("uid://diys2hqublq37")
const BOMB = preload("uid://d01tyaukbh447")

var abilities : Array[ String ] = [
	"BOOMERANG", "GRAPPLE", "BOW", "BOMB"
]

var selected_ability : int = 0
var player : Player
var boomerang_instance : Boomerang = null

@onready var state_machine: PlayerStateMachine = $"../StateMachine"
@onready var idle: State_Idle = $"../StateMachine/Idle"
@onready var walk: State_Walk = $"../StateMachine/Walk"
@onready var lift: State_Lift = $"../StateMachine/Lift"
@onready var bow: State_Bow = $"../StateMachine/Bow"
@onready var grapple: State_Grapple = $"../StateMachine/Grapple"

func _ready():
	player = PlayerManager.player
	PlayerHud.update_arrow_count( player.arrow_count )
	PlayerHud.update_bomb_count( player.bomb_count )
	pass

func _unhandled_input( event : InputEvent ):
	if event.is_action_pressed("ability"):
		match selected_ability:
			0: boomerang_ability()
			1: grapple_ability()
			2: bow_ability()
			3: bomb_ability()
	elif event.is_action_pressed("switch_ability"):
		toggle_ability()
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

func grapple_ability():
	if state_machine.current_state == idle or state_machine.current_state == walk:
		# change to grapple state
		player.state_machine.change_state( grapple )
	pass
	
func bomb_ability():
	if player.bomb_count <= 0:
		return
	else:
		if state_machine.current_state == idle or state_machine.current_state == walk:
			# Decrease bomb count
			player.bomb_count -= 1
			# Update player hud
			PlayerHud.update_bomb_count( player.bomb_count )
			# Initialize a new bomb
			var bomb : Node2D = BOMB.instantiate()
			player.add_sibling( bomb )
			bomb.position = player.position
			lift.animation_seek = 0.2
			PlayerManager.interact_handled = false
			var throwable : Throwable = bomb.find_child( "Throwable" )
			throwable.player_interact()
	pass

func bow_ability():
	if player.arrow_count <= 0:
		return
	else:
		if state_machine.current_state == idle or state_machine.current_state == walk:
			# Decrease arrow count
			player.arrow_count -= 1
			# Update player hud
			PlayerHud.update_arrow_count( player.arrow_count )
			# Change to bow state
			player.state_machine.change_state( bow )
	pass

func toggle_ability():
	selected_ability = wrapi( selected_ability + 1, 0, 4 )
	PlayerHud.update_ability_ui( selected_ability )
	
