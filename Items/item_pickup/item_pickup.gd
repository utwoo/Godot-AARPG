@tool

class_name ItemPickup
extends CharacterBody2D

@export var item_data : ItemData : set = set_item_data

@onready var area_2d : Area2D = $Area2D
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var audio_stream_player_2d : AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	update_texture()
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
			if PlayerManager.INVENTORY_DATA.add_item( item_data ):
				item_picked_up()
			
	pass
	
func item_picked_up():
	area_2d.body_entered.disconnect( _on_body_entered )
	audio_stream_player_2d.play()
	visible = false
	await audio_stream_player_2d.finished
	queue_free()
	pass

func update_texture():
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture
	pass
	

func set_item_data( value : ItemData ):
	item_data = value
	pass
