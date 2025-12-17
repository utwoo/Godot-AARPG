extends CanvasLayer

@onready var button_save = $Control/HBoxContainer/ButtonSave 
@onready var button_load = $Control/HBoxContainer/ButtonLoad

var is_paused : bool = false

func _ready():
	hide_pause_menu()
	button_save.pressed.connect(_on_save_pressed)
	button_load.pressed.connect(_on_load_pressed)
	pass

func _unhandled_input( event: InputEvent ):
	if event.is_action_pressed("pause"):
		if is_paused == false:
			show_pause_menu()
		else:
			hide_pause_menu()
	get_viewport().set_input_as_handled()
pass

func show_pause_menu():
	get_tree().paused = true
	visible = true
	is_paused = true
	button_save.grab_focus()
	
func hide_pause_menu():
	get_tree().paused = false
	visible = false
	is_paused = false
	
func _on_save_pressed():
	if is_paused == false:
		return
	
	SaveManager.save_game()
	hide_pause_menu()
	pass
	
func _on_load_pressed():
	if is_paused == false:
		return
	
	SaveManager.load_game()
	await LevelManager.level_load_started
	hide_pause_menu()
	pass
