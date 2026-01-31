@icon("res://GUI/DialogSystem/icons/star_bubble.svg")
class_name DialogSystemNode
extends CanvasLayer

signal finished
signal letter_added ( letter : String )

var is_active : bool = false

var dialog_items : Array[ DialogItem ]
var dialog_item_index : int = 0

var text_in_progress : bool = false
var text_speed : float = 0.02
var text_length : int = 0
var plain_text : String

@onready var dialog_ui : Control = $DialogUI
@onready var content : RichTextLabel = $DialogUI/PanelContainer/RichTextLabel
@onready var name_lable : Label = $DialogUI/NameLable
@onready var portrait_sprite : DialogPortrait = $DialogUI/PortraitSprite
@onready var dialog_progress_indicator : PanelContainer = $DialogUI/DialogProgressIndicator
@onready var dialog_progress_indicator_label : Label = $DialogUI/DialogProgressIndicator/Label
@onready var timer : Timer = $DialogUI/Timer
@onready var audio : AudioStreamPlayer = $DialogUI/AudioStreamPlayer


func _ready():
	timer.timeout.connect( _on_timer_timeout )
	hide_dialog()
	pass


func _unhandled_input( _event : InputEvent ):
	if is_active == false:
		return
	
	if _event.is_action_pressed("interact"):
		if text_in_progress == true:
			content.visible_characters = text_length
			timer.stop()
			text_in_progress = false
			show_dialog_button_indicator( true )
			return
		
		dialog_item_index += 1
		if dialog_item_index < dialog_items.size():
			start_dialog()
		else:
			hide_dialog()
	pass


func show_dialog( _items : Array[ DialogItem ] ):
	is_active = true
	dialog_ui.visible = true
	dialog_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	dialog_items = _items
	dialog_item_index = 0
	get_tree().paused = true
	await get_tree().process_frame
	start_dialog()
	pass
	
	
func hide_dialog():
	is_active = false
	dialog_ui.visible = false
	dialog_ui.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	finished.emit()
	pass


func start_dialog():
	show_dialog_button_indicator( false )
	var dialogItem : DialogItem = dialog_items[ dialog_item_index ]
	set_dialog_data( dialogItem )
	
	content.visible_characters = 0
	text_length = content.get_total_character_count()
	plain_text = content.get_parsed_text()
	text_in_progress = true
	start_timer()
	pass

func set_dialog_data( dialogItem : DialogItem ):
	if dialogItem is DialogText:
		content.text = dialogItem.text
		portrait_sprite.texture = dialogItem.npc_info.portrait
		portrait_sprite.audio_pitch_base = dialogItem.npc_info.dialog_audio_pitch
		name_lable.text = dialogItem.npc_info.npc_name
	pass

func show_dialog_button_indicator( _is_visible : bool ):
	dialog_progress_indicator.visible = _is_visible
	if dialog_item_index < dialog_items.size() - 1:
		dialog_progress_indicator_label.text = "NEXT"
	else:
		dialog_progress_indicator_label.text = "END"

func start_timer():
	timer.wait_time = text_speed
	timer.start()
	pass
	
func _on_timer_timeout():
	content.visible_characters += 1
	if content.visible_characters <= text_length:
		letter_added.emit( plain_text[ content.visible_characters - 1 ] )
		start_timer()
	else:
		show_dialog_button_indicator( true )
		text_in_progress = false
	pass
