class_name State_Attack
extends State

@export var attack_sound : AudioStream
@export_range(1,20,0.5) var decelerate_speed : float = 5

@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var animation_attack : AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AttackAnimation"
@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

@onready var walk : State = $"../Walk"
@onready var idle : State = $"../Idle"

var attacking : bool = false

# What happen when the player enters this state
func Enter() -> void:
	# attack and effect
	player.UpdateAnimation("attack")
	animation_attack.play("attack_" + player.AnimDirection())
	
	animation_player.animation_finished.connect(EndAttack)
	# attack sound
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	
	attacking = true

# What happen during the _process update in this state
func Process(_delta) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	
	return null

# What happen when the player exits this state
func Exit() -> void:
	animation_player.animation_finished.disconnect(EndAttack)
	attacking = false
	
func EndAttack(_newAnimName:String):
	attacking = false
