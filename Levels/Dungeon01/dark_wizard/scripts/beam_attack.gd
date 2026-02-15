class_name BeamAttack
extends Node2D

@export var use_timer : bool = false
@export var time_between_attack : float = 3.0

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	if use_timer == true:
		attack_delay()
	pass
	

func attack():
	animation_player.play( "attack" )
	await animation_player.animation_finished
	animation_player.play( "default" )
	if use_timer == true:
		attack_delay()
	
func attack_delay():
	await get_tree().create_timer( time_between_attack ).timeout
	attack()
	pass
