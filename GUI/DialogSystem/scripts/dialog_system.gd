@icon("res://GUI/DialogSystem/icons/star_bubble.svg")
class_name DialogSystemNode
extends CanvasLayer

signal finished

var dialog_items : Array[ DialogItem ]
var dialog_item_index : int = 0
var is_active : bool = false

@onready var dialog_ui : Control = $DialogUI
@onready var content : RichTextLabel = $DialogUI/PanelContainer/RichTextLabel
@onready var name_lable : Label = $DialogUI/NameLable
@onready var portrait_sprite : Sprite2D = $DialogUI/PortraitSprite
@onready var dialog_progress_indicator : PanelContainer = $DialogUI/DialogProgressIndicator
@onready var dialog_progress_indicator_label : Label = $DialogUI/DialogProgressIndicator/Label


func _ready():
	hide_dialog()
	pass


func _unhandled_input( _event : InputEvent ):
	if is_active == false:
		return
	
	if _event.is_action_pressed("interact"):
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
	show_dialog_button_indicator( true )
	var dialogItem : DialogItem = dialog_items[ dialog_item_index ]
	set_dialog_data( dialogItem )
	pass

func set_dialog_data( dialogItem : DialogItem ):
	if dialogItem is DialogItem:
		content.text = dialogItem.text
		portrait_sprite.texture = dialogItem.npc_info.portrait
		name_lable.text = dialogItem.npc_info.npc_name
	pass

func show_dialog_button_indicator( _is_visible : bool ):
	dialog_progress_indicator.visible = _is_visible
	if dialog_item_index < dialog_items.size() - 1:
		dialog_progress_indicator_label.text = "NEXT"
	else:
		dialog_progress_indicator_label.text = "END"
	
