@icon("res://NPC/Icons/npc.svg")
@tool
class_name NPC
extends CharacterBody2D

signal do_behavior_enabled

var state : String = "idle"
var direction : Vector2 = Vector2.DOWN
var direction_name : String = "down"
var do_behavior : bool = true

@export var npc_resource : NPCResource : set = _set_npc_resource
@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D

func _ready():
	setup_npc()
	
	if Engine.is_editor_hint():
		return
		
	do_behavior_enabled.emit()
	pass
	
func _physics_process( _delta : float ):
	move_and_slide()

func update_animation():
	animation.play( state + "_" + direction_name )
	
func update_direction( target_postion : Vector2 ):
	direction = global_position.direction_to( target_postion )
	update_direction_name()
	if direction_name == "side" and direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		
func update_direction_name():
	var threshold : float = 0.45
	if direction.y < -threshold:
		direction_name = "up"
	elif direction.y > threshold:
		direction_name = "down"
	elif  direction.x > threshold || direction.x < -threshold:
		direction_name = "side"
	
func setup_npc():
	if npc_resource and sprite:
		sprite.texture = npc_resource.sprite
	pass
	
func _set_npc_resource( npc : NPCResource ):
	npc_resource = npc
	setup_npc()
