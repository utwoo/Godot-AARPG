extends Sprite2D

var FRAME_COUNT : int = 128

@onready var sprite_weapon_below: Sprite2D = $Sprite2D_Weapon_Below
@onready var sprite_weapon_above: Sprite2D = $Sprite2D_Weapon_Above

func _ready() -> void:
	PlayerManager.INVENTORY_DATA.equipment_changed.connect( _on_equipment_changed )
	pass


func _process( _delta: float ) -> void:
	sprite_weapon_below.frame = frame
	sprite_weapon_above.frame = frame + FRAME_COUNT
	pass
	

func _on_equipment_changed():
	var equipment = PlayerManager.INVENTORY_DATA.equipment_slots()
	texture = equipment[0].item_data.sprite_texture
	sprite_weapon_below.texture = equipment[1].item_data.sprite_texture
	sprite_weapon_above.texture = equipment[1].item_data.sprite_texture
	pass
