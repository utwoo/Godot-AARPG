extends CanvasLayer

@export var button_focus_audio : AudioStream = preload("res://TitleScene/audio/menu_focus.wav")
@export var button_select_audio : AudioStream = preload("res://TitleScene/audio/menu_select.wav")

var hearts : Array[ HeartGUI ] = []

@onready var game_over : Control = $Control/GameOver
@onready var continue_button : Button = $Control/GameOver/VBoxContainer/ContinueButton
@onready var title_button : Button = $Control/GameOver/VBoxContainer/TitleButton
@onready var animation_player : AnimationPlayer = $Control/GameOver/AnimationPlayer
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer

@onready var boss_ui : Control = $Control/BossUI
@onready var boss_hp_bar : TextureProgressBar = $Control/BossUI/TextureProgressBar
@onready var boss_label : Label = $Control/BossUI/Label

@onready var notification_ui: NotificationUI = $Control/Notification

func _ready():
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append(child)
			child.visible = false
	pass
	
	hide_game_over_screen()
	
	continue_button.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	continue_button.pressed.connect( load_game )
	title_button.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	title_button.pressed.connect( title_screen )
	
	LevelManager.level_load_started.connect( hide_game_over_screen )
	
	hide_boss_health()
	
	pass

func update_hp( _hp: int, _max_hp: int ):
	update_max_hp(_max_hp)
	for i in roundi( _max_hp * 0.5 ) :
		update_heart( i, _hp )
		pass
	pass
	
	
func update_heart( _index: int, _hp: int ):
	var _value : int = clampi( _hp - _index * 2, 0, 2 )
	hearts[ _index ].value = _value
	pass
	
	
func update_max_hp( _max_hp: int):
	var heart_count : int = roundi( _max_hp * 0.5 )
	for i in hearts.size():
		if i < heart_count:
			hearts[ i ].visible = true
		else:
			hearts[ i ].visible = false
	pass
	

func hide_game_over_screen():
	game_over.visible = false
	game_over.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_over.modulate = Color( 1, 1, 1, 0 )
	
func show_game_over_screen():
	game_over.visible = true
	game_over.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var can_continue : bool = SaveManager.get_save_file() != null
	continue_button.visible = can_continue
	
	animation_player.play( "show_game_over" )
	await animation_player.animation_finished
	
	if can_continue:
		continue_button.grab_focus()
	else:
		title_button.grab_focus()
	
func load_game():
	play_audio( button_select_audio )
	await fade_to_black()
	SaveManager.load_game()
	pass
	

func fade_to_black() -> bool:
	animation_player.play( "fade_to_black" )
	await animation_player.animation_finished
	PlayerManager.player.revive_player()
	return true


func title_screen():
	play_audio( button_select_audio )
	await fade_to_black()
	LevelManager.load_new_level( "res://TitleScene/title_scene.tscn", "", Vector2.ZERO )
	pass


func play_audio( _audio : AudioStream ):
	audio.stream = _audio
	audio.play()


func show_boss_health( boss_name : String ):
	boss_ui.visible = true
	boss_label.text = boss_name
	update_boss_health( 1, 1 )
	pass


func hide_boss_health():
	boss_ui.visible = false
	pass
	
func update_boss_health( hp : int, max_hp : int ):
	boss_hp_bar.value = clampf( ( float(hp) / float(max_hp) ) * 100, 0, 100 )
	
	pass
	

func queue_notification( _title : String, _message : String ):
	notification_ui.add_notification_to_queue( _title, _message )
	pass
