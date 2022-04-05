extends VBoxContainer


onready var player_data = get_parent().get_node("player_data")
onready var combat_sim = get_parent().get_node("combat_sim")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func refresh_results():
	#print_specials( player_data )
	
	$p_maxhit.value = combat_sim.p_max_hit
	$p_hitchance.value = stepify( combat_sim.p_hit_chance * 100, 0.01 )
	$p_dps.value = stepify( combat_sim.p_dps, 0.01 )
	$p_dps2.value = stepify( combat_sim.p_dps2, 0.01 )
	$spk.value = stepify( combat_sim.time_to_kill2, 0.01 )
	
	$m_maxhit.value = combat_sim.m_max_hit
	$m_hitchance.value = stepify( combat_sim.m_hit_chance  * 100, 0.01 )
	$m_dps.value = stepify( combat_sim.m_dps, 0.1 )
	
	pass

func print_specials( player_data : player ):
	print("SPECIALS")
	var specials_str = ""
	for special in player_data.special_attributes:
		specials_str += "* " + HardcodedData.equipment_specials[ special ][ "description" ]
		if "implemented" in HardcodedData.equipment_specials[ special ] and HardcodedData.equipment_specials[ special ][ "implemented" ] == false:
			specials_str += " (not implemented)"
		specials_str += "\n"
	$special_desc.parse_bbcode( specials_str )
	pass
