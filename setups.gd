extends TabContainer


@onready var setup_scene : Resource = preload( "res://interface/set.tscn" )

var test : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_new_setup_pressed() -> void:
	var new_setup : Node = setup_scene.instantiate()
	new_setup.name = str( get_child_count() )
	add_child( new_setup )



func _on_equipment_list_item_selected(item_node : equipment) -> void:
	get_current_tab_control().player_equip( item_node )


func _on_monster_item_selected(monster_node : monster) -> void:
	get_current_tab_control().set_monster( monster_node )

func _on_prayer_list_prayer_selected(prayer_id : String) -> void:
	get_current_tab_control().prayer_add( prayer_id )


func _on_save_set_pressed() -> void:
	DisplayServer.clipboard_set( get_current_tab_control().save_data() )


func _on_load_set_pressed() -> void:
	get_current_tab_control().load_data( DisplayServer.clipboard_get() )


func _on_Button_pressed() -> void:
	if get_tab_count() > 1:
		get_current_tab_control().queue_free()
