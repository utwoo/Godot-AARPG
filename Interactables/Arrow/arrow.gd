extends Node2D

@export var move_speed : float = 300.0
@export var fire_audio : AudioStream

var move_direction : Vector2 = Vector2.RIGHT

@onready var hurt_box: HurtBox = $HurtBox
@onready var arrow_sprite: Sprite2D = $ArrowSprite2D
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	hurt_box.did_damage.connect( _on_did_damage )
	get_tree().create_timer( 10.0 ).timeout.connect( _on_timeout )
	if fire_audio:
		audio_stream_player.stream = fire_audio
		audio_stream_player.play()
	pass
	
func _physics_process(delta: float) -> void:
	position += move_direction * move_speed * delta
	
func fire( fire_direction : Vector2 ):
	move_direction = fire_direction
	rotation_node()
	pass
	
func rotation_node():
	var angle = move_direction.angle()
	arrow_sprite.rotation = angle
	hurt_box.rotation = angle
	pass
	
func _on_did_damage():
	queue_free()
	pass
	
func _on_timeout():
	queue_free()
	pass
