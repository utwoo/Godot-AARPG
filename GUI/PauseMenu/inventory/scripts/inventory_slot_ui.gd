class_name InventorySlotUI
extends Button

var slot_data : SlotData : set = set_slot_data
var click_pos : Vector2 = Vector2.ZERO
var dragging : bool = false
var dragging_texture : Control
var dragging_threshold : float = 16.0

@onready var texture_rect : TextureRect = $TextureRect
@onready var label : Label = $Label

func _ready():
	texture_rect.texture = null
	label.text = ""
	focus_entered.connect( item_focused )
	focus_exited.connect( item_unfocused )
	pressed.connect( item_pressed )
	button_down.connect( on_button_down )
	button_up.connect( on_button_up )
	
func _process(_delta: float) -> void:
	if dragging:
		dragging_texture.global_position = get_global_mouse_position() - Vector2(16, 16)
		if outside_drag_threshold():
			dragging_texture.modulate.a = 0.5
		else:
			dragging_texture.modulate.a = 0.0
	
func set_slot_data( value : SlotData ):
	slot_data = value
	if slot_data == null:
		texture_rect.texture = null
		label.text = ""
		return
	
	texture_rect.texture = slot_data.item_data.texture
	
	if slot_data.item_data is EquipableItemData:
		label.text = ""
	else:
		label.text = str( slot_data.quantity )
	
func item_focused():
	PauseMenu.focused_item_changed( slot_data )
	pass
	
func item_unfocused():
	PauseMenu.focused_item_changed( null )
	pass

func item_pressed():
	if slot_data and not outside_drag_threshold():
		if slot_data.item_data:
			var item = slot_data.item_data
			
			if item is EquipableItemData:
				PlayerManager.INVENTORY_DATA.equip_item( slot_data )
				return
			
			var was_used = item.use()
			if was_used == false:
				return
			slot_data.quantity -= 1
			
			if slot_data:
				label.text = str( slot_data.quantity )
			
func on_button_down():
	click_pos = get_global_mouse_position()
	dragging = true
	dragging_texture = texture_rect.duplicate()
	dragging_texture.z_index = 10
	dragging_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dragging_texture)
	
func on_button_up():
	dragging = false
	if dragging_texture:
		dragging_texture.queue_free()
		
func outside_drag_threshold() -> bool:
	return get_global_mouse_position().distance_to( click_pos ) >= dragging_threshold
	
