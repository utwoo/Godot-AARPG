class_name InventroyUI
extends Node

const INVENTORY_SLOT = preload("res://GUI/PauseMenu/inventory/inventory_slot.tscn")

var focus_index : int = 0
var hovered_item : InventorySlotUI

@export var data : InventoryData

@onready var inventory_slot_armor : InventorySlotUI = %InventorySlot_Armor
@onready var inventory_slot_amulet : InventorySlotUI = %InventorySlot_Amulet
@onready var inventory_slot_weapon : InventorySlotUI = %InventorySlot_Weapon
@onready var inventory_slot_ring : InventorySlotUI = %InventorySlot_Ring

func _ready():
	PauseMenu.shown.connect( update_inventory )
	PauseMenu.hidden.connect( clear_inventory )
	clear_inventory()
	data.changed.connect( on_inventory_changed )
	data.equipment_changed.connect( on_inventory_changed )
	pass
	
func clear_inventory():
	for c in get_children():
		c.set_slot_data( null )

func update_inventory( apply_focus : bool = true ):
	clear_inventory()
	
	var invetory_slots : Array[ SlotData ] = data.inventory_slots()
	
	for i in invetory_slots.size():
		var slot : InventorySlotUI = get_child( i )
		slot.set_slot_data( invetory_slots[ i ] )
		connect_item_signals( slot )
	
	# Update eqiupment slots
	var e_slots : Array[ SlotData ] = data.equipment_slots()
	inventory_slot_armor.set_slot_data( e_slots[ 0 ] )
	inventory_slot_weapon.set_slot_data( e_slots[ 1 ] )
	inventory_slot_amulet.set_slot_data( e_slots[ 2 ] )
	inventory_slot_ring.set_slot_data( e_slots [ 3 ] )
	
	if apply_focus:
		get_child( 0 ).grab_focus()

func item_foucsed():
	for i in get_child_count():
		if get_child( i ).has_focus():
			focus_index = i
			return
			
	pass
 
func on_inventory_changed():  
	update_inventory( false )
	
func connect_item_signals( item : InventorySlotUI ): 
	if not item.button_up.is_connected( on_item_drop ):
		item.button_up.connect( on_item_drop.bind( item ) )
	
	if not item.mouse_entered.is_connected( on_item_mouse_entered ):
		item.mouse_entered.connect( on_item_mouse_entered.bind( item ))
	
	if not item.mouse_exited.is_connected( on_item_mouse_exited ):
		item.mouse_exited.connect( on_item_mouse_exited)
	
func on_item_drop( item: InventorySlotUI ):
	if item == null or hovered_item == null or item == hovered_item:
		return
	else:
		data.swap_item_by_index( item.get_index(), hovered_item.get_index() )
		update_inventory( false )
	pass
	
func on_item_mouse_entered( item : InventorySlotUI ):
	hovered_item = item
	pass
	
func on_item_mouse_exited():
	hovered_item = null
	pass
