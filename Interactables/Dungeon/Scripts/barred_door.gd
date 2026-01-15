class_name BarredDoor
extends Node2D

@onready var animation_player = $AnimationPlayer

func _ready():
	pass
	

func open_door():
	animation_player.play("open_door")
	pass


func close_door():
	animation_player.play("close_door")
	pass
