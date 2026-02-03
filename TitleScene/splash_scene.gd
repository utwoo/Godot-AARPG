extends Control

signal finished

func _ready():
	$MichaelGamesLogo/AnimationPlayer.animation_finished.connect( _on_animation_finished )


func _on_animation_finished( _name : String ):
	finished.emit()
