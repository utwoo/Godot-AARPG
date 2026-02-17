class_name Pathfinder
extends Node2D

var vectors : Array[ Vector2 ] = [
	Vector2(0,-1), #UP
	Vector2(1,-1), #UP/RIGHT
	Vector2(1,0),  #RIGHT
	Vector2(1,1),  #DOWN/RIGHT
	Vector2(0,1),  #DOWN
	Vector2(-1,1), #DOWN/LEFT
	Vector2(-1,0), #LEFT
	Vector2(-1,-1)  #UP/LEFT
]

var interests : Array[ float ]
var obstacles :  Array[ float ] = [ 0, 0, 0, 0, 0, 0, 0, 0 ]
var outcomes :  Array[ float ] = [ 0, 0, 0, 0, 0, 0, 0, 0 ]
var rays : Array[ RayCast2D ]

var move_direction : Vector2 = Vector2.ZERO
var best_path : Vector2 = Vector2.ZERO

@onready var timer : Timer = $Timer

func _ready():
	# Gather all Raycast2D Nodes
	for c in get_children():
		if c is RayCast2D:
			rays.append( c )
	
	# Normalize all vectors
	for v in vectors:
		v = v.normalized()
		
	# Perform initial pathfinder function
	set_path()
	
	# Connect timer
	timer.timeout.connect( set_path )
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( _delta ):
	move_direction = lerp( move_direction, best_path, 10 * _delta )
	pass
	
# Set the best path vector by checking for desired direction and considering obstacles
func set_path():
	# Get direction to the player
	var player_direction : Vector2 = global_position.direction_to( PlayerManager.player.global_position )
	
	# Reset obstacles values to 0
	for i in obstacles.size():
		obstacles[ i ] = 0
		outcomes [ i ] = 0
	
	# Check each Raycast2D for collisions & update values in obstacles array
	for i in obstacles.size():
		if rays[ i ].is_colliding():
			obstacles[ i ] += 4
			obstacles[ get_next_i( i ) ] += 1
			obstacles[ get_prev_i( i ) ] += 1
	
	# If there are no obstacles, recommend path in direction of player
	if obstacles.max() == 0:
		best_path = player_direction
		return
	
	# Populate our interest array. This array contains values that represent
	# the desireability of each direction ( dot product )
	interests.clear()
	for v in vectors:
		interests.append( v.dot( player_direction ) )
	
	# Popular outcomes array, by combining interest and obstacle arrays
	for i in obstacles.size():
		outcomes[ i ] = interests[ i ] - obstacles[ i ]
	
	# Set the best path with the Vector2 that corresponds with the outcome with the highest value
	best_path = vectors[ outcomes.find( outcomes.max() ) ]
	pass


func get_prev_i( i : int ) -> int:
	var result : int = i - 1
	if result < 0:
		return 7
	else:
		return result


func get_next_i( i : int ) -> int:
	var result : int = i + 1
	if result >= 8:
		return 0
	else:
		return result
