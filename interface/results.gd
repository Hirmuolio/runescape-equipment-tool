extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func refresh_results():
	$p_maxhit.value = CombatSim.p_max_hit
	$p_hitchance.value = stepify( CombatSim.p_hit_chance * 100, 0.1 )
	$p_dps.value = CombatSim.p_dps
	$p_dps2.value = CombatSim.p_dps2
	$spk.value = CombatSim.time_to_kill2
	
	$m_maxhit.value = CombatSim.m_max_hit
	$m_hitchance.value = stepify( CombatSim.m_hit_chance  * 100, 0.1 )
	$m_dps.value = CombatSim.m_dps
	
	pass
