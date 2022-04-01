extends Node


var p_max_hit : int
var p_hit_chance : float
var p_dps : float
var p_dps2 : float
var time_to_kill : float
var time_to_kill2 : float

var m_max_hit : int
var m_hit_chance : float
var m_dps : float

signal simulation_done()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func clear_results():
	p_dps2 = 0
	time_to_kill2 = 0
	pass

func calc_special_melee_damage_bonus( player : player, target_mon : monster ) -> float:
	
	var multiplier : float = 1
	
	for effect_name in player.special_attributes:
		if "melee_dmg_mult" in HardcodedData.equipment_specials[effect_name]:
			multiplier *= HardcodedData.equipment_specials[effect_name]["melee_dmg_mult"]
		if effect_name == "dharok":
			multiplier *= 1 + ( player.hp_lvl - player.current_hp ) * player.hp_lvl * 0.0001
	
	return multiplier

func calc_special_melee_acc_bonus( player : player, target_mon : monster ) -> float:
	
	var multiplier : float = 1
	
	for effect_name in player.special_attributes:
		if "melee_acc_mult" in HardcodedData.equipment_specials[effect_name]:
			multiplier *= HardcodedData.equipment_specials[effect_name]["melee_acc_mult"]
	
	return multiplier


func do_fast_simulations( player : player, target_mon : monster ):
	clear_results()
	if !player:
		print( "NO PLAYER EXISTS")
		return
	if !target_mon:
		print( "NO TARGET MONSTER")
		return
	
	calc_p_max_hit( player, target_mon )
	calc_p_hit_chance( player, target_mon )
	
	p_dps = p_hit_chance * p_max_hit / 2 / player.attack_speed / 0.6
	time_to_kill = target_mon.hitpoints / p_dps
	
	calc_m_hit_chance( player, target_mon )
	m_max_hit = target_mon.max_hit
	
	m_dps = m_hit_chance * m_max_hit / 2 / target_mon.attack_speed / 0.6
	
	emit_signal("simulation_done")

func do_simulations( player : player, target_mon : monster ):
	clear_results()
	if !player:
		print( "NO PLAYER EXISTS")
		return
	if !target_mon:
		print( "NO TARGET MONSTER")
		return
	
	calc_p_max_hit( player, target_mon )
	calc_p_hit_chance( player, target_mon )
	
	p_dps = p_hit_chance * p_max_hit / 2 / player.attack_speed / 0.6
	time_to_kill = target_mon.hitpoints / p_dps
	
	calc_m_hit_chance( player, target_mon )
	m_max_hit = target_mon.max_hit
	
	m_dps = m_hit_chance * m_max_hit / 2 / target_mon.attack_speed / 0.6
	
	
	simulate_combat( player, target_mon )
	
	
	
	emit_signal("simulation_done")

func calc_p_max_hit( player : player, target_mon : monster ):
	
	# Melee
	var eff_str = floor( (floor( player.strength * player.prayer_str ) + player.style_str_bonus + 8) )
	
	var base_damage = 0.5 + eff_str * ( player.str_bonus + 64 ) / 640
	
	var special_bonus : float = calc_special_melee_damage_bonus( player, target_mon )
	
	p_max_hit = floor( base_damage * special_bonus )



func calc_p_hit_chance( player : player, target_mon : monster ):
	
	# Melee
	var eff_atk = floor( ( floor( player.attack * player.prayer_atk ) + player.style_atk_bonus + 8) * player.other_atk_bonus )
	
	var special_bonus : float = calc_special_melee_acc_bonus( player, target_mon )
	
	var atk_roll = floor( eff_atk * ( player.atk_bonus  + 64 ) * special_bonus )
	
	
	
	var def_roll = ( target_mon.defence_level + 9 ) * ( target_mon.style_def( player.attack_style ) + 64 )
	
	
	if atk_roll > def_roll:
		p_hit_chance = 1 - 0.5 * ( def_roll + 2 ) / ( atk_roll + 1 )
	else:
		p_hit_chance = 0.5 * atk_roll / ( def_roll + 1 )

func calc_m_hit_chance( player : player, target_mon : monster ):
	
	# Melee
	var eff_atk = target_mon.attack_level + 8
	var atk_roll = floor( eff_atk * ( target_mon.attack_bonus  + 64 ) )
	
	var eff_def = floor( ( floor( player.defence * player.prayer_def ) + player.style_def_bonus + 8) * player.other_def_bonus )
	var def_roll = eff_def * ( player.style_def( target_mon.attack_type ) + 64 )
	
	
	if atk_roll > def_roll:
		m_hit_chance = 1 - 0.5 * ( def_roll + 2 ) / ( atk_roll + 1 )
	else:
		m_hit_chance = 0.5 * atk_roll / ( def_roll + 1 )

func simulate_combat( player : player, target_mon : monster ):
	
	# Full tick accurate combat simulation
	var tick = 0
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var simulated_kills = 100000
	for _kills in range(1, simulated_kills): #1000 rounds
		var target_hp = target_mon.hitpoints
		while target_hp > 0:
			if( tick % player.attack_speed  == 0):
				# Player attacks
				if rng.randf() < p_hit_chance:
					target_hp -= rng.randi_range( 0, p_max_hit)
			tick += 1
	
	p_dps2 = ( simulated_kills * target_mon.hitpoints ) / ( tick * 0.6 )
	time_to_kill2 =  ( tick * 0.6 ) / simulated_kills
	
	
