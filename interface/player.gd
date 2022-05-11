extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func refresh_eq_stats():
	var player_stats = get_parent().get_parent().get_node( "player_data" )
	
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
	get_node( "eq_other/speed" ).text = str( player_stats.get_equipment_bonus( "attack_speed" ) )
	
	
	pass

func stat_string( value : int ) -> String:
	if value < 0:
		return str(value)
	
	return "+" + str(value)
	
