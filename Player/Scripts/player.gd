class_name Player
extends CharacterBody2D

var cardinal_direction = Vector2.DOWN
var direction  = Vector2.ZERO

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var state_machine = $StateMachine

signal DirectionChanged(new_direction:Vector2)

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.Initialize(self)

func _process(_delta):
	direction = Input.get_vector("left", "right", "up", "down").normalized()

func _physics_process(_delta):
	move_and_slide()

func SetDirection() -> bool:
	var new_direction = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	
	if abs(direction.x) > abs(direction.y):
		new_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	else:
		new_direction = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_direction == cardinal_direction:
		return false
	
	cardinal_direction = new_direction
	DirectionChanged.emit(new_direction)
	sprite_2d.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	
	return true


func UpdateAnimation(state:String) -> void:
	animation_player.play( state + "_" + AnimDirection())
	
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
