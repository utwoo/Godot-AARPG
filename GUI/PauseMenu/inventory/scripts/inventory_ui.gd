class_name InventroyUI
extends Node

const INVENTORY_SLOT = preload("res://GUI/PauseMenu/inventory/inventory_slot.tscn")

var focus_index : int = 0

@export var data : InventoryData

func _ready():
	PauseMenu.shown.connect( update_inventory )
	PauseMenu.hidden.connect( clear_inventory )
	clear_inventory()
	data.changed.connect( on_inventory_changed )
	pass
	
func clear_inventory():
	for c in get_children():
		c.queue_free()

func update_inventory( i : int = 0):
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child( new_slot )
		new_slot.slot_data = s
		new_slot.focus_entered.connect( item_foucsed )
		
	await get_tree().process_frame
	get_child( i ).grab_focus()

func item_foucsed():
	for i in get_child_count():
		if get_child( i ).has_focus():
			focus_index = i
			return
			
	pass
 
func on_inventory_changed():
	clear_inventory()
	update_inventory( focus_index )
