extends VBoxContainer


@onready var player_data : player = get_parent().get_parent().get_node("player_data") # TODO make nicer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _on_combat_sim_simulation_done( stats : dps_stats ) -> void:
	#print_specials( player_data )
	
	$p_maxhit.value = stats.max_hit
	
	var max_hoover_info : String = ""
	max_hoover_info += "Base max hit: " + str( stats.max_hit )
	if stats.max_hit != stats.max_critical:
		max_hoover_info += "\nCritical hit: " + str( stats.max_critical )
	$p_maxhit.hoover_info = max_hoover_info
	$p_hitchance.value = str( snapped( stats.hit_chance * 100, 0.01 ) ) + "%"
	$p_hitchance2.value = str( snapped( stats.hit_chance_simulated * 100, 0.01 ) ) + "%"
	$p_hitchance.hoover_info = "Approximation from stats. Does not apply all special effects.\nPlayer attack roll: " + str(stats.player_atk_roll) + "\nMonster def roll: " + str(stats.monster_def_roll)
	$p_hitchance2.hoover_info = "Result from simulated combat.\nPlayer attack roll: " + str(stats.player_atk_roll) + "\nMonster def roll: " + str(stats.monster_def_roll) + "\nHitting 0 is counted as miss."
	$p_dps.value = snapped( stats.dps, 0.01 )
	$p_dps2.value = snapped( stats.dps_simulated, 0.01 )
	
	if stats.ttk:
		$spk.value = str( snapped( stats.ttk, 0.01 ) ) + " s"
	else:
		$spk.value = ""
	
	$m_maxhit.value = stats.monster_max_hit
	$m_hitchance.value = str( snapped( stats.monster_hit_chance  * 100, 0.01 ) ) + "%"
	$m_hitchance.hoover_info = "Monster attack roll: " + str(stats.monster_atk_roll)+ "\nPlayer def roll: " + str(stats.player_def_roll)
	$m_dps.value = snapped( stats.monster_dps, 0.1 )
	
	var drain_res : float = 2 * player_data.get_equipment_bonus( "prayer" ) + 60
	var drain : float = 0
	for prayer : String in player_data.prayers:
		drain += HardcodedData.prayers[prayer].drain
	if drain > 0:
		var seconds_per_drain : float = 0.6 * ( drain_res / drain )
		var drain_per_minute : float = 60 / seconds_per_drain
		$pray_drain.value = str( int(drain_per_minute * 1000)/1000.0 ) + " points/minute"
	else:
		$pray_drain.value = ""
	$pray_drain.hoover_info = "Total drain: " + str(drain) + "\nDrain resistance: " + str( drain_res )

func print_specials() -> void:
	
	$special_desc.clear()
	
	for special : String in player_data.special_attributes:
		$special_desc.add_text ( "  " + HardcodedData.equipment_specials[ special ][ "name" ] )
		$special_desc.newline()
		$special_desc.append_text( HardcodedData.equipment_specials[ special ][ "description" ] )
		$special_desc.newline()
		$special_desc.newline()
		#$special_desc.pop()
