class_name Stats
extends PanelContainer

@onready var level_label : Label = $VBoxContainer/LevelContainer/Value
@onready var xp_label : Label = $VBoxContainer/XPContainer/Value
@onready var attack_label : Label = $VBoxContainer/AttackContainer/Value
@onready var defense_label : Label = $VBoxContainer/DefenseContainer/Value

func _ready():
	PauseMenu.shown.connect( update_stats )
	pass 

func update_stats():
	var player : Player = PlayerManager.player
	level_label.text = str( player.level )
	xp_label.text = str( player.xp ) + "/" + str( PlayerManager.level_requirements[ player.level ] )
	attack_label.text = str( player.attack )
	defense_label.text = str( player.defense )
	pass
