class_name State_Dash
extends State

@export var move_speed : float = 200.0
@export var effect_delay : float = 0.1
@export var effect_audio : AudioStream

@onready var idle: State = $"../Idle"

var direction : Vector2 = Vector2.ZERO
var next_state : State = null
var effect_timer : float = 0.0

# What happen when the player enters this state
func enter() -> void:
	player.invulnerable = true
	player.update_animation( "dash" )
	player.animation_player.animation_finished.connect( on_animation_finished )
	direction = player.direction
	if direction == Vector2.ZERO:
		direction = player.cardinal_direction
	if effect_audio:
		player.play_audio( effect_audio )
	effect_timer = 0
	pass

# What happen when the player exits this state
func exit() -> void:
	player.invulnerable = false
	player.animation_player.animation_finished.disconnect( on_animation_finished )
	next_state = null
	pass

# What happen during the _process update in this state
func process( _delta : float ) -> State:
	player.velocity = move_speed * direction
	effect_timer -= _delta
	if effect_timer < 0:
		effect_timer = effect_delay
		spawn_effect()
	return next_state

# What happen during the _physics_process update in this state
func physics( _delta : float ) -> State:
	return null

# What happen with input events update in this state	
func handle_input( _event : InputEvent ) -> State:
	return null

func on_animation_finished( _animate_name : String):
	next_state = idle
	pass

func spawn_effect():
	var effect : Node2D = Node2D.new()
	effect.global_position = player.global_position - Vector2( 0, 0.1 )
	effect.modulate = Color(1.5, 0.2, 1.25, 0.75)
	player.get_parent().add_child( effect )
	
	var sprite_copy = player.sprite_2d.duplicate()
	effect.add_child( sprite_copy )
	
	var tween : Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property( effect, "modulate", Color(1, 1, 1, 0), 0.2)
	tween.tween_callback( effect.queue_free )
	
	pass
	
	
