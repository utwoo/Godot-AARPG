class_name State_Death
extends State

@export var exhaust_audio : AudioStream

@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

func _ready():
	pass # Replace with function body.

# What happen when we initialize this state
func init() -> void:
	pass
	
# What happen when the player enters this state
func enter() -> void:
	player.animation_player.play( "death" )
	audio.stream = exhaust_audio
	audio.play()
	PlayerHud.show_game_over_screen()
	AudioManager.play_music( null )
	pass

# What happen when the player exits this state
func exit() -> void:
	pass

# What happen during the _process update in this state
func process( _delta : float ) -> State:
	player.velocity = Vector2.ZERO
	return null

# What happen during the _physics_process update in this state
func physics( _delta : float ) -> State:
	return null

# What happen with input events update in this state	
func handle_input( _event : InputEvent ) -> State:
	return null
