class_name Stats
extends PanelContainer

var inventory : InventoryData

@onready var level_label : Label = $VBoxContainer/LevelXPContainer/ValueLevel
@onready var xp_label : Label = $VBoxContainer/LevelXPContainer/ValueXP
@onready var attack_label : Label = $VBoxContainer/AttackDefenseContainer/ValueAttack
@onready var defense_label : Label = $VBoxContainer/AttackDefenseContainer/ValueDefense
@onready var attack_change_label : Label = $VBoxContainer/AttackDefenseContainer/ValueAttackChange
@onready var defense_change_label : Label = $VBoxContainer/AttackDefenseContainer/ValueDefenseChange

func _ready():
	PauseMenu.shown.connect( update_stats )
	PauseMenu.preview_stats_changed.connect( _on_preview_stats_changed )
	inventory = PlayerManager.INVENTORY_DATA
	inventory.equipment_changed.connect( update_stats )
	pass 

func update_stats():
	var player : Player = PlayerManager.player
	level_label.text = str( player.level )
	
	if player.level < PlayerManager.level_requirements.size():
		xp_label.text = str( player.xp ) + "/" + str( PlayerManager.level_requirements[ player.level ] )
	else:
		xp_label.text = "MAX LVL"
	
	attack_label.text = str( player.attack + inventory.get_attack_bonus() )
	defense_label.text = str( player.defense + inventory.get_defense_bonus() )
	pass
	

func _on_preview_stats_changed( item : ItemData ):
	attack_change_label.text = ""
	defense_change_label.text = ""
	
	if not item is EquipableItemData:
		return
		
	var equipment : EquipableItemData = item
	var attack_delta : int = inventory.get_attack_bonus_diff( equipment )
	var defense_delta : int = inventory.get_defense_bonus_diff( equipment )
	
	update_change_label( attack_change_label, attack_delta )
	update_change_label( defense_change_label, defense_delta )
	
	pass
	

func update_change_label( label : Label, value : int ) -> void:
	if value > 0:
		label.text = "+" + str( value )
		label.modulate = Color.LIGHT_GREEN
	elif value < 0:
		label.text = str( value )
		label.modulate = Color.INDIAN_RED
	pass
