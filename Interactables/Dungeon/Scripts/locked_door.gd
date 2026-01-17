class_name LockedDoor
extends Node2D

var is_open : bool = false

@export var key_item : ItemData

@export var locked_audio : AudioStream
@export var open_audio : AudioStream

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var is_open_data : PersistentDataHandler = $PersistentDataHandler
@onready var interact_area : Area2D = $InteractArea

func _ready():
	interact_area.area_entered.connect( _on_area_entered )
	interact_area.area_exited.connect( _on_area_exited )
	is_open_data.data_loaded.connect( set_state )
	set_state()
	pass
	
func open_door():
	if key_item == null:
		return
	
	var door_unlocked = PlayerManager.INVENTORY_DATA.use_item( key_item )
	
	if door_unlocked:
		animation_player.play("opened")
		audio.stream = open_audio
		is_open_data.set_value()
	else:
		audio.stream = locked_audio
		
	audio.play()
	pass

func set_state():
	is_open = is_open_data.value
	if is_open:
		animation_player.play("opened")
	else:
		animation_player.play("closed")
	pass

func _on_area_entered( _area : Area2D ):
	PlayerManager.interact_pressed.connect( open_door )
	pass

func _on_area_exited( _area : Area2D ):
	PlayerManager.interact_pressed.disconnect( open_door )
	pass
