class_name Plant
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$HitBox.damaged.connect(take_damage)

func take_damage( _damage : HurtBox ):
	queue_free()
