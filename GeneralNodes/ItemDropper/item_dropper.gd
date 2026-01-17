@tool

class_name ItemDropper
extends Node2D

const PICKUP = preload("res://Items/item_pickup/item_pickup.tscn")

@export var item_data : ItemData : set = _set_item_data

var has_dropped : bool = false

@onready var sprite : Sprite2D = $Sprite2D
@onready var has_dropper_data : PersistentDataHandler = $PersistentDataHandler
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	if Engine.is_editor_hint():
		_update_texture()
		return
	
	sprite.visible = false
	has_dropper_data.data_loaded.connect( _on_data_loaded )
	_on_data_loaded()
	
func drop_item():
	if has_dropped:
		return
	
	has_dropped = true
	
	var drop = PICKUP.instantiate() as ItemPickup
	drop.item_data = item_data
	add_child( drop )
	drop.pick_up.connect( _on_item_pickup )
	audio.play()

func _on_data_loaded():
	has_dropped = has_dropper_data.value
	
func _on_item_pickup():
	has_dropper_data.set_value()

func _set_item_data( item : ItemData ):
	item_data = item
	_update_texture()

func _update_texture():
	if Engine.is_editor_hint() == false:
		return
	
	if item_data and sprite:
		sprite.texture = item_data.texture
