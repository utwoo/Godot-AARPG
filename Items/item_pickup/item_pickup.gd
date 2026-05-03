@tool

class_name ItemPickup
extends CharacterBody2D

signal pick_up

@export var item_data : ItemData : set = set_item_data
@export var item_count : int  = 1 : set = set_item_count

@onready var area_2d : Area2D = $Area2D
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var audio_stream_player_2d : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var count_label: Label = %CountLabel

func _ready():
	update_texture()
	update_count_label()
	if Engine.is_editor_hint():
		return
		
	area_2d.body_entered.connect( _on_body_entered )

func _physics_process( delta : float ):
		#TODO: what is collision_info and bounce
		var collision_info = move_and_collide( velocity * delta )
		if collision_info:
			velocity.bounce( collision_info.get_normal() )
		velocity -= velocity * delta * 4

func  _on_body_entered( b ):
	if b is Player:
		if item_data:
			if item_data.name == "Bomb":
				PlayerManager.player.bomb_count += item_count
			elif item_data.name == "Arrow":
				PlayerManager.player.arrow_count += item_count
			else:
				PlayerManager.INVENTORY_DATA.add_item( item_data, item_count )
			item_picked_up()
			
	pass
	
func item_picked_up():
	area_2d.body_entered.disconnect( _on_body_entered )
	audio_stream_player_2d.play()
	visible = false
	pick_up.emit()
	await audio_stream_player_2d.finished
	queue_free()
	pass

func update_texture():
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture
	pass

func update_count_label():
	if item_data and count_label:
		count_label.text = ""
		if item_count > 1:
			count_label.text = str( item_count )
	pass
	
func set_item_data( value : ItemData ):
	item_data = value
	pass
	
func set_item_count( value : int ):
	item_count = value
	update_count_label()
	pass
