class_name HitBox
extends Area2D

signal Damaged(damage:int)

func TakeDamage(damage:int):
	print("TakeDamage: ", damage)
	Damaged.emit(damage)
