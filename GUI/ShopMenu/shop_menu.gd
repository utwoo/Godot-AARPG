extends CanvasLayer

signal shown
signal hidden

const ERROR = preload("uid://du50wlq4mvly7")
const OPEN_SHOP = preload("uid://cgdwh3bpdtssc")
const PURCHASE = preload("uid://cdlwcdftc4f84")

var is_active : bool = false

@onready var close_button: Button = %CloseButton
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide_menu()
	close_button.pressed.connect( hide_menu )
	pass
	

func _unhandled_input(event: InputEvent) -> void:
	if not is_active:
		return
	
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		hide_menu()

func show_menu( items : Array[ ItemData ] ):
	print(items)
	await DialogSystem.finished
	enabled_menu()
	shown.emit()
	play_audio( OPEN_SHOP )
	pass
	
func hide_menu():
	enabled_menu( false )
	hidden.emit()
	pass
	
func enabled_menu( enabled : bool = true ):
	get_tree().paused = enabled
	visible = enabled
	is_active = enabled
	
func play_audio( audio : AudioStream ):
	audio_stream_player.stream = audio
	audio_stream_player.play()
