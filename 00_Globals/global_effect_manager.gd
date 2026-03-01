extends Node

const DAMAGE_TEXT = preload("uid://cikal6ho8n878")

func damage_text( _damage : String, _postion : Vector2 ):
	var _t : DamageText = DAMAGE_TEXT.instantiate()
	add_child( _t )
	_t.start( str( _damage ), _postion )
	pass
