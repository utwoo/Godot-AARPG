class_name LevelTileMapLayer
extends TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManager.change_tilemap_bounds( get_tilemap_bounds() )
	pass
	

func get_tilemap_bounds() -> Array[ Vector2 ]:
	var bounds :  Array[ Vector2 ] = []
	bounds.append( Vector2 ( get_used_rect().position * rendering_quadrant_size ) )
	bounds.append( Vector2 ( get_used_rect().end * rendering_quadrant_size ) )
	return bounds
