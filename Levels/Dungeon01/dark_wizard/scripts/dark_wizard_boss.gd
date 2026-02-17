class_name DarkWizardBoss
extends Node2D

const ENERGY_EXPLOSION_SCENE : PackedScene = preload("res://Levels/Dungeon01/dark_wizard/energy_explosion.tscn")
const ENERGY_BALL_SCENE : PackedScene = preload("res://Levels/Dungeon01/dark_wizard/energy_orb.tscn")

@export var max_hp : int = 10

var hp : int = 10
var current_postion : int = 0
var positions : Array[ Vector2 ]
var beam_attacks : Array[ BeamAttack ]

var damage_count : int = 0

@onready var boss_node : Node2D = $BossNode
@onready var audio : AudioStreamPlayer2D = $BossNode/AudioStreamPlayer2D
@onready var animation_player : AnimationPlayer = $BossNode/AnimationPlayer
@onready var animation_player_damaged : AnimationPlayer = $BossNode/AnimationPlayer_Damaged
@onready var animation_player_cloak : AnimationPlayer = $BossNode/CloakSprite/AnimationPlayer
@onready var persistent_data_handler : PersistentDataHandler = $BossNode/PersistentDataHandler
@onready var hurt_box : HurtBox = $BossNode/HurtBox
@onready var hit_box : HitBox = $BossNode/HitBox
@onready var door_block : TileMapLayer = $"../DoorBlock"

@onready var hand_01_down : Sprite2D = $BossNode/CloakSprite/Hand01_DOWN
@onready var hand_02_down : Sprite2D = $BossNode/CloakSprite/Hand02_DOWN
@onready var hand_01_up : Sprite2D = $BossNode/CloakSprite/Hand01_UP
@onready var hand_02_up : Sprite2D = $BossNode/CloakSprite/Hand02_UP
@onready var hand_01_side : Sprite2D = $BossNode/CloakSprite/Hand01_SIDE
@onready var hand_02_side : Sprite2D = $BossNode/CloakSprite/Hand02_SIDE

var audio_hurt : AudioStream = preload("res://Levels/Dungeon01/dark_wizard/audio/boss_hurt.wav")
var audio_shoot : AudioStream = preload("res://Levels/Dungeon01/dark_wizard/audio/boss_fireball.wav")

func _ready():
	
	persistent_data_handler.get_value()
	if persistent_data_handler.value == true:
		door_block.enabled = false
		queue_free()
		return
	
	hp = max_hp
	PlayerHud.show_boss_health( "Dark Wizard" )
	hit_box.damaged.connect( damage_taken )
	# postions
	$PositionTargets.visible = false
	for c in $PositionTargets.get_children():
		positions.append( c.global_position )
	# beam attacks
	for c in $BeamAttacks.get_children():
		beam_attacks.append( c )
		
	teleport( 0 )
	pass
	

func _process( _delta : float ):
	hand_01_up.frame = hand_01_down.frame + 4
	hand_02_up.frame = hand_02_down.frame + 4
	hand_01_side.frame = hand_01_down.frame + 8
	hand_02_side.frame = hand_02_down.frame + 12
	pass
	

func teleport( _location : int ):
	# disappear
	animation_player.play( "disappear" )
	enable_hit_boxes( false )
	damage_count = 0
	# wait 1 second
	await get_tree().create_timer( 1 ).timeout
	# appear
	boss_node.global_position = positions[ _location ]
	current_postion = _location
	update_animation()
	animation_player.play( "appear" )
	await animation_player.animation_finished
	# idle
	idle()
	pass
	
	
func idle():
	enable_hit_boxes()
	
	if randf() >= float(hp) / float(max_hp):
		animation_player.play( "idle" )
		await animation_player.animation_finished
	
	shoot_orb()
	
	if damage_count < 1:
		energy_beam_attack()
	
		animation_player.play( "cast_spell" )
		await animation_player.animation_finished
	
	if hp < 1:
		return
	
	var _t : int = current_postion
	while _t == current_postion:
		_t = randi_range( 0, positions.size() - 1)
	
	teleport( _t )
	pass


func energy_beam_attack():
	var _b : Array[ int ]
	match current_postion:
		0:
			_b.append( 0 )
			_b.append( randi_range( 1, 2 ) )
		2:
			_b.append( 2 )
			_b.append( randi_range( 0, 1 ) )
		1: 
			_b.append( 3 )
			_b.append( randi_range( 4, 5 ) )
		3: 
			_b.append( 5 )
			_b.append( randi_range( 3, 4 ) )
	for b in _b:
		beam_attacks[ b ].attack()
	pass
	

func shoot_orb():
	var eb : Node2D = ENERGY_BALL_SCENE.instantiate() as EnergyOrb
	eb.global_position = boss_node.global_position + Vector2( 0, -34 )
	eb.speed = 100
	get_parent().add_child.call_deferred( eb )
	play_audio( audio_shoot )
	pass
	
	
func damage_taken( _hurt_box : HurtBox):
	if animation_player_damaged.current_animation == "damaged" or _hurt_box.damage == 0:
		return
	
	hp = clampi( hp - _hurt_box.damage, 0, max_hp )
	damage_count += 1
	PlayerHud.update_boss_health( hp, max_hp )
	play_audio( audio_hurt )
	
	animation_player_damaged.play( "damaged" )
	animation_player_damaged.seek( 0 )
	animation_player_damaged.queue( "default" )
	if hp < 1:
		defeat()
	pass
	

func update_animation():
	boss_node.scale = Vector2( 1, 1 )
	
	hand_01_down.visible = false
	hand_02_down.visible = false
	hand_01_up.visible = false
	hand_02_up.visible = false
	hand_01_side.visible = false
	hand_02_side.visible = false
	
	if current_postion == 0:
		animation_player_cloak.play( "down" )
		hand_01_down.visible = true
		hand_02_down.visible = true
	elif current_postion == 2:
		animation_player_cloak.play( "up" )
		hand_01_up.visible = true
		hand_02_up.visible = true
	else:
		animation_player_cloak.play( "side" )
		hand_01_side.visible = true
		hand_02_side.visible = true
		if current_postion == 1:
			boss_node.scale = Vector2( -1, 1 )
	pass
	

func play_audio( _audio : AudioStream ):
	audio.stream = _audio
	audio.play()


func defeat():
	animation_player.play( "destroy" )
	enable_hit_boxes( false )
	PlayerHud.hide_boss_health()
	persistent_data_handler.set_value()
	await animation_player.animation_finished
	door_block.enabled = false

func enable_hit_boxes( value : bool = true ):
	hit_box.set_deferred( "monitorable", value)
	hurt_box.set_deferred( "monitoring", value)

func explosion ( vector : Vector2 = Vector2.ZERO ):
	var e : Sprite2D = ENERGY_EXPLOSION_SCENE.instantiate()
	e.global_position = boss_node.global_position + vector
	get_parent().add_child.call_deferred( e )
	
