class_name ItemEffectHeal
extends ItemEffect

@export var heal_amount : int = 1
@export var audio : AudioStream

func use():
	PlayerManager.player.update_hp( heal_amount )
	PauseMenu.play_audio( audio )
