class_name State_Attack
extends State

@export var attack_sound : AudioStream
@export_range(1, 20, 0.5) var decelerate_speed : float = 5

@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var animation_attack : AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AttackAnimation"
@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var hurt_box : HurtBox = %AttackHurtBox

@onready var walk : State = $"../Walk"
@onready var idle : State = $"../Idle"
@onready var charge_attack : State = $"../ChargeAttack"

var attacking : bool = false

# What happen when the player enters this state
func enter() -> void:
	# attack and effect
	player.update_animation("attack")
	animation_attack.play("attack" + "_" +  player.anim_direction())
	animation_player.animation_finished.connect(end_attack)
	# attack sound
	audio.stream = attack_sound
	audio.pitch_scale = randf_range( 0.9, 1.1 )
	audio.play()
	
	attacking = true
	
	await get_tree().create_timer(0.075).timeout
	
	if attacking:
		hurt_box.monitoring = true
	
	pass

# What happen during the _process update in this state
func process(_delta) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	
	return null

# What happen when the player exits this state
func exit() -> void:
	animation_player.animation_finished.disconnect(end_attack)
	attacking = false
	hurt_box.monitoring = false
	pass
	
func end_attack(_newAnimName:String):
	if Input.is_action_pressed("attack"):
		state_machine.change_state( charge_attack )
	attacking = false
	pass
