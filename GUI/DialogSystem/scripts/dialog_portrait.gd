class_name DialogPortrait
extends Sprite2D

var blink : bool = false : set = _set_blink
var open_mouth : bool = false : set = _set_open_mouth
var mouth_open_frames : int = 0
var audio_pitch_base : float = 1.0

@onready var audio : AudioStreamPlayer = $"../AudioStreamPlayer"

func _ready():
	if Engine.is_editor_hint():
		return
	
	DialogSystem.letter_added.connect( check_mouth_open )
	blinker()

func check_mouth_open( letter : String ):
	if "aeiouy1234567890".contains( letter ):
		open_mouth = true
		mouth_open_frames += 3
		audio.pitch_scale = randf_range( audio_pitch_base - 0.04, audio_pitch_base + 0.04 )
		audio.play()
	elif ".,!?".contains( letter ):
		mouth_open_frames = 0
		
	if mouth_open_frames > 0:
		mouth_open_frames -= 1
	
	if mouth_open_frames == 0:
		open_mouth = false
	
	pass

func update_portrait():
	if open_mouth == true:
		frame = 2
	else:
		frame = 0
	pass
	
	if blink == true:
		frame += 1

func blinker():
	if blink == false:
		await get_tree().create_timer( randf_range( 0.1, 3 ) ).timeout
	else:
		await get_tree().create_timer( 0.15 ).timeout
		
	blink = not blink
	blinker()
	
func _set_blink( value : bool ):
	if blink != value:
		blink = value
		update_portrait()
	pass
	
func _set_open_mouth( value : bool ):
	if open_mouth != value:
		open_mouth = value
		update_portrait()
	pass
