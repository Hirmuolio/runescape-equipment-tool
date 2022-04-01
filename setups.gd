extends TabContainer


onready var setup_scene = preload( "res://interface/set.tscn" )


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_new_setup_pressed():
	var new_setup = setup_scene.instance()
	new_setup.name = String( get_child_count() )
	add_child( new_setup )



func _on_equipment_list_item_selected(item_node):
	get_current_tab_control().player_equip( item_node )


func _on_monster_item_selected(monster_node):
	get_current_tab_control().set_monster( monster_node )

