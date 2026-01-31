@tool
extends NPCBehavior

const DIRECTIONS = [ Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT ]

@export var wander_range : int = 2 : set = _set_wander_range
@export var wander_speed : float = 30.0
@export var wander_duration : float = 1.0
@export var idle_duration : float = 1.0

var original_postion : Vector2

func _ready():
	if Engine.is_editor_hint():
		return
	
	super()
	$CollisionShape2D.queue_free() 
	original_postion = npc.global_position
	
	pass
	
func _physics_process( _delta : float ):
	if Engine.is_editor_hint():
		return
	
	if abs( global_position.distance_to( original_postion ) ) > wander_range * 32:
		npc.velocity *= -1
		npc.direction *= -1
		npc.update_direction( global_position + npc.direction )
		npc.update_animation()

func start():
	# IDLE PHASE
	if npc.do_behavior == false:
		return
	
	npc.state = "idle"
	npc.velocity = Vector2.ZERO
	npc.update_animation()
	
	await get_tree().create_timer( ( randf() + 0.5 ) * idle_duration ).timeout
	
	# WALK PHASE
	if npc.do_behavior == false:
		return
		
	npc.state = "walk"
	npc.direction = DIRECTIONS[ randi_range( 0, 3 ) ]
	npc.velocity = wander_speed * npc.direction
	npc.update_direction( global_position + npc.direction )
	npc.update_animation()
	
	await get_tree().create_timer( ( randf() + 0.5 ) * wander_duration ).timeout
	
	#REPEAT
	if npc.do_behavior == false:
		return
	start()
	pass

func _set_wander_range( value : int ):
	wander_range = value
	$CollisionShape2D.shape.radius = value * 32.0
	
	
