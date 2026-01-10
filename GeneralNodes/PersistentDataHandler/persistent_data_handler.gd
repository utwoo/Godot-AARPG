class_name PersistentDataHandler
extends Node

var value : bool = false

func _ready():
	get_value()
	pass
	 
func set_value():
	SaveManager.add_persistent_value( _get_name() )
	pass
	
func get_value():
	value = SaveManager.check_persistent_value( _get_name() )
	pass

func _get_name() -> String:
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name 
