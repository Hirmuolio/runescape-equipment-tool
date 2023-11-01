extends VBoxContainer


@onready var player_stats = get_parent().get_parent().get_node( "player_data" )

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func refresh_eq_stats():
	#var player_stats = get_parent().get_parent().get_node( "player_data" )
	
	get_node( "eq_attack/stab" ).text = stat_string( player_stats.get_equipment_bonus( "attack_stab" ) )
	get_node( "eq_attack/slash" ).text = stat_string( player_stats.get_equipment_bonus( "attack_slash" ) )
	get_node( "eq_attack/crush" ).text = stat_string( player_stats.get_equipment_bonus( "attack_crush" ) )
	get_node( "eq_attack/magic" ).text = stat_string( player_stats.get_equipment_bonus( "attack_magic" ) )
	get_node( "eq_attack/ranged" ).text = stat_string( player_stats.get_equipment_bonus( "attack_ranged" ) )
	
	get_node( "eq_def/stab" ).text = stat_string( player_stats.get_equipment_bonus( "defence_stab" ) )
	get_node( "eq_def/slash" ).text = stat_string( player_stats.get_equipment_bonus( "defence_slash" ) )
	get_node( "eq_def/crush" ).text = stat_string( player_stats.get_equipment_bonus( "defence_crush" ) )
	get_node( "eq_def/magic" ).text = stat_string( player_stats.get_equipment_bonus( "defence_magic" ) )
	get_node( "eq_def/ranged" ).text = stat_string( player_stats.get_equipment_bonus( "defence_ranged" ) )
	
	get_node( "eq_other/str" ).text = stat_string( player_stats.get_equipment_bonus( "melee_strength" ) )
	get_node( "eq_other/rng_str" ).text = stat_string( player_stats.get_equipment_bonus( "ranged_strength" ) )
	get_node( "eq_other/mg_dmg" ).text = "+" + str( player_stats.get_equipment_bonus( "magic_damage_bonus" ) ) + "%"
	get_node( "eq_other/pray" ).text = stat_string( player_stats.get_equipment_bonus( "prayer" ) )
	get_node( "eq_other/speed" ).text = str( player_stats.attack_speed )
	
	
	pass

func stat_string( value : int ) -> String:
	if value < 0:
		return str(value)
	
	return "+" + str(value)
	


func _on_player_data_prayers_changed():
	
	for child in $prayers.get_children():
		child.queue_free()
	
	var prayer_button_scene := preload( "res://interface/pray_button.tscn")
	
	for prayer in player_stats.prayers:
		var button := prayer_button_scene.instantiate()
		button.pray_id = prayer
		var _err1 = button.connect("button_down",Callable(player_stats,"prayer_remove").bind(prayer))
		var _err2 = button.connect("button_down",Callable(button,"remove_button"))
		$prayers.add_child( button )
	
	


func _on_attack_style_attack_style(_new_stance):
	# Attack speed needs refreshing
	# Just refresh all
	refresh_eq_stats()
