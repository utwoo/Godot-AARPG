@tool

class_name TreasureChest
extends Node2D

@export var item_data : ItemData : set = _set_item_data
@export var quantity : int = 1 : set = _set_quantity

var is_open : bool = false

@onready var sprite: Sprite2D = $ItemSprite
@onready var label : Label = $ItemSprite/Label
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var interact_area : Area2D = $Area2D
@onready var is_open_data : PersistentDataHandler = $IsOpen

func _ready():
	_update_texture()
	_update_label()
	
	if Engine.is_editor_hint():
		return
		
	interact_area.area_entered.connect( _on_area_enter )
	interact_area.area_exited.connect( _on_area_exit )
	set_chest_state()
	pass

func _on_area_enter( _area : Area2D ):
	PlayerManager.interact_pressed.connect( player_interact )
	pass
	
func player_interact():
	if is_open:
		return
	
	is_open = true
	is_open_data.set_value()
	animation_player.play("open_chest")
	
	if item_data and quantity > 0:
		PlayerManager.INVENTORY_DATA.add_item( item_data, quantity )
	else:
		push_error("No items in chest! Chest Name: ", name)
	pass


func _on_area_exit( _area : Area2D ):
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


func _set_item_data( value : ItemData ): 
	item_data = value
	_update_texture()
	pass


func _set_quantity( value : int ):
	quantity = value
	_update_label()
	pass
	
func _update_texture():
	if item_data and sprite:
		sprite.texture = item_data.texture
	pass	
		
func _update_label():
	if label:
		if quantity <= 1:
			label.text = ""
		else:
			label.text = "x" + str( quantity )
	pass

func set_chest_state():
	is_open = is_open_data.value
	if is_open:
		animation_player.play("opened")
	else:
		animation_player.play("closed")
	pass
