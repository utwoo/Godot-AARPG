class_name HurtBox
extends Area2D

@export var damage : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(entered)

func entered( area2d : Area2D ):
	if area2d is HitBox:
		area2d.take_damage(damage)
