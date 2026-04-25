extends CanvasLayer

signal shown
signal hidden

const ERROR = preload("uid://du50wlq4mvly7")
const OPEN_SHOP = preload("uid://cgdwh3bpdtssc")
const PURCHASE = preload("uid://cdlwcdftc4f84")
const MENU_FOCUS = preload("uid://bimua1kikwboo")
const MENU_SELECT = preload("uid://dlaey2pmdwdit")

const SHOP_ITEM_BUTTON = preload("uid://dy4tmy24455ro")

const gem : ItemData = preload("uid://bedqtc5g48wpg")

var is_active : bool = false

@onready var close_button: Button = %CloseButton
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var shop_items_container: VBoxContainer = %ShopItemsContainer
@onready var gems_label: Label = %GemsLabel
@onready var animation_player: AnimationPlayer = $Control/PanelContainer/HBoxContainer/AnimationPlayer

@onready var item_image: TextureRect = $Control/DetailsPanel/Control/ItemImage
@onready var item_name: Label = $Control/DetailsPanel/Control/ItemName
@onready var item_description: Label = $Control/DetailsPanel/Control/ItemDescription
@onready var item_price: Label = %ItemPrice
@onready var item_held_count: Label = %ItemHeldCount

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
	populate_item_list( items )
	update_gems()
	shop_items_container.get_child( 0 ).grab_focus()
	shown.emit()
	play_audio( OPEN_SHOP )
	pass
	
func hide_menu():
	enabled_menu( false )
	clear_item_list()
	hidden.emit()
	pass
	
func enabled_menu( enabled : bool = true ):
	get_tree().paused = enabled
	visible = enabled
	is_active = enabled
	
func update_gems():
	gems_label.text = str(get_item_quantity( gem ))
	
func get_item_quantity( item : ItemData ) -> int:
	return PlayerManager.INVENTORY_DATA.get_item_held_quantity( item )
	
func clear_item_list():
	for c in shop_items_container.get_children():
		c.queue_free()
	
func populate_item_list( items : Array[ ItemData ] ):
	for item in items:
		var shop_item : ShopItemButton = SHOP_ITEM_BUTTON.instantiate()
		shop_item.setup_item( item )
		shop_item.focus_entered.connect( focus_item_changed.bind( item ) )
		shop_item.pressed.connect( purchase_item.bind( item ))
		shop_items_container.add_child( shop_item)
		
func focus_item_changed( item : ItemData ):
	play_audio( MENU_FOCUS )
	if item:
		update_item_detail( item )
		
func update_item_detail( item : ItemData ):
	item_image.texture = item.texture
	item_name.text = item.name
	item_description.text = item.description
	item_price.text = str( item.cost )
	item_held_count.text = str( get_item_quantity( item ) )

func purchase_item( item : ItemData ):
	var can_purchase : bool = get_item_quantity( gem ) >= item.cost
	
	if can_purchase:
		var inventory = PlayerManager.INVENTORY_DATA;
		inventory.add_item( item )
		inventory.use_item( gem, item.cost )
		update_gems()
		update_item_detail( item )
	else:
		play_audio(ERROR)
		animation_player.play("not_enough_gems")
		animation_player.seek( 0 )
	pass
	
func play_audio( audio : AudioStream ):
	audio_stream_player.stream = audio
	audio_stream_player.play()
