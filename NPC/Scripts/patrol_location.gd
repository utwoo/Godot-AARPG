@tool
class_name PatrolLocation
extends Node2D

signal tranform_changed

@export var wait_time : float = 0.0 :
	set( value ):
		wait_time = value
		_update_wait_time_label()

var target_position : Vector2 = Vector2.ZERO

func _enter_tree():
	set_notify_transform( true )
	pass

func _notification( what: int ):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		tranform_changed.emit()
 
func _ready():
	target_position = global_position
	_update_wait_time_label() 
	
	if Engine.is_editor_hint():
		return
		
	$Sprite2D.queue_free()
	
	pass
	
func update_label( s : String ):
	$Sprite2D/Label.text = s
	
func update_line( next_location : Vector2 ):
	var line : Line2D = $Sprite2D/Line2D
	line.points[ 1 ] = next_location - position
	pass
	
func _update_wait_time_label():
	if Engine.is_editor_hint():
		$Sprite2D/Label2.text = "wait: " + str( snapped( wait_time, 0.01 ) ) + "s"
	pass
