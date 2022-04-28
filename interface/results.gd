extends VBoxContainer


onready var player_data = get_parent().get_node("player_data")
onready var combat_sim = get_parent().get_node("combat_sim")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func refresh_results():
	#print_specials( player_data )
	
	$p_maxhit.value = combat_sim.p_max_hit
	
	var max_hoover_info : String = ""
	max_hoover_info += "Base max hit: " + str( combat_sim.base_max_hit )
	if combat_sim.p_max_hit != combat_sim.crit_max_hit:
		max_hoover_info += "\nCritical hit: " + str( combat_sim.crit_max_hit )
	$p_maxhit.hoover_info = max_hoover_info
	$p_hitchance.value = str( stepify( combat_sim.p_hit_chance * 100, 0.01 ) ) + "%"
	$p_hitchance.hoover_info = "Player attack roll: " + str(combat_sim.p_hit_roll) + "\nMonster def roll: " + str(combat_sim.m_def_roll)
	$p_dps.value = stepify( combat_sim.p_dps, 0.01 )
	$p_dps2.value = stepify( combat_sim.p_dps2, 0.01 )
	$spk.value = stepify( combat_sim.time_to_kill2, 0.01 )
	
	$m_maxhit.value = combat_sim.m_max_hit
	$m_hitchance.value = str( stepify( combat_sim.m_hit_chance  * 100, 0.01 ) ) + "%"
	$m_hitchance.hoover_info = "Monster attack roll: " + str(combat_sim.m_hit_roll)+ "\nPlayer def roll: " + str(combat_sim.p_def_roll)
	$m_dps.value = stepify( combat_sim.m_dps, 0.1 )
	
	pass

func print_specials():
	
	$special_desc.clear()
	
	for special in player_data.special_attributes:
		$special_desc.add_text ( "  " + HardcodedData.equipment_specials[ special ][ "name" ] )
		$special_desc.newline()
		$special_desc.append_bbcode ( HardcodedData.equipment_specials[ special ][ "description" ] )
		$special_desc.newline()
		$special_desc.newline()
		#$special_desc.pop()
