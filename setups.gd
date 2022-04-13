extends TabContainer


onready var setup_scene = preload( "res://interface/set.tscn" )

var test : String = ""

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

func _on_prayer_list_prayer_selected(prayer_id):
	get_current_tab_control().prayer_add( prayer_id )


func _on_save_set_pressed():
	OS.set_clipboard( get_current_tab_control().save_data() )
	#print( test )
	pass # Replace with function body.


func _on_load_set_pressed():
	get_current_tab_control().load_data( OS.get_clipboard() )
	pass # Replace with function body.


func _on_Button_pressed():
	if get_tab_count() > 1:
		get_current_tab_control().queue_free()
