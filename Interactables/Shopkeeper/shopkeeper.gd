extends Node2D

@export var shop_inventory : Array[ ItemData ]
@onready var dialog_branch_yes: DialogBranch = $NPC/DialogInteraction/DialogChoice/DialogBranchYes

func _ready() -> void:
	dialog_branch_yes.selected.connect( show_shop_menu )
	pass

func show_shop_menu():
	ShopMenu.show_menu( shop_inventory )
	pass
