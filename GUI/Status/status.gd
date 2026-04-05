class_name Stats
extends PanelContainer

@onready var level_label : Label = $VBoxContainer/LevelXPContainer/ValueLevel
@onready var xp_label : Label = $VBoxContainer/LevelXPContainer/ValueXP
@onready var attack_label : Label = $VBoxContainer/AttackDefenseContainer/ValueAttack
@onready var defense_label : Label = $VBoxContainer/AttackDefenseContainer/ValueDefense
@onready var value_attack_change : Label = $VBoxContainer/AttackDefenseContainer/ValueAttackChange
@onready var value_defense_change : Label = $VBoxContainer/AttackDefenseContainer/ValueDefenseChange

func _ready():
	PauseMenu.shown.connect( update_stats )
	pass 

func update_stats():
	var player : Player = PlayerManager.player
	level_label.text = str( player.level )
	
	if player.level < PlayerManager.level_requirements.size():
		xp_label.text = str( player.xp ) + "/" + str( PlayerManager.level_requirements[ player.level ] )
	else:
		xp_label.text = "MAX LVL"
	
	attack_label.text = str( player.attack )
	defense_label.text = str( player.defense )
	pass
