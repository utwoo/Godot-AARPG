extends Node

var current_tilemap_bounds : Array[ Vector2 ]
signal TileMapBoundsChanges( bounds : Array [ Vector2 ] )

func ChangeTileMapBounds( bounds : Array [ Vector2 ] ):
	current_tilemap_bounds = bounds
	TileMapBoundsChanges.emit( bounds )
