class_name Throwable
extends Area2D

@export var gravity_strength : float = 980
@export var throw_speed : float = 400
@export var throw_height_strength : float = 100
@export var throw_starting_height : float = 49

var picked_up : bool = false
var throwable : Node2D 

@onready var hurt_box : HurtBox = $HurtBox

func _ready():
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	throwable = get_parent()
	setup_hurt_box()
	pass
	

func _on_area_enter( _area : Area2D ):
	PlayerManager.interact_pressed.connect( player_interact )
	pass
	
	
func _on_area_exit( _area : Area2D ):
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


func player_interact():
	if not picked_up:
		pass
	pass

func setup_hurt_box():
	hurt_box.monitoring = false
	for c in get_children():
		if c is CollisionShape2D:
			var _col : CollisionShape2D = c.duplicate()
			_col.debug_color = Color(1,0,0,0.5)
			hurt_box.add_child( _col )
	pass
