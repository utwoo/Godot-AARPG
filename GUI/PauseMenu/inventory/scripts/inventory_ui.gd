class_name InventroyUI
extends Node

const INVENTORY_SLOT = preload("res://GUI/PauseMenu/inventory/inventory_slot.tscn")

@export var data : InventoryData

func _ready():
	PauseMenu.shown.connect( update_inventory )
	PauseMenu.hidden.connect( clear_inventory )
	clear_inventory()
	pass
	
func clear_inventory():
	for c in get_children():
		c.queue_free()

func update_inventory():
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child( new_slot )
		new_slot.slot_data = s
		
		
	get_child( 0 ).grab_focus()
 
