extends Node


var p_max_hit : int
var base_max_hit : int
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
	var eff_str : int = Utl.ifloor( player.strength * player.prayer_str ) + player.style_str_bonus + 8
	
	var max_hit : int = Utl.ifloor( 0.5 + eff_str * ( player.str_bonus + 64 ) / 640.0 )
	base_max_hit = max_hit
	# Special bonuses need to be applied in specific order
	#Order:
	# Obsidian armor before salve (e)
	# Obsidian armor before berserker necklace
	# Black mask before berserker necklace
	# Black mask before special attack
	# Keris ?
	# silver/dark/ardc ?
	# Void ?
	# viggora ?
	# Dharok ?
	
	if "void_melee" in player.special_attributes:
		max_hit = Utl.ifloor( max_hit * 1.1 )
	if "obsidian_armor" in player.special_attributes:
		max_hit = Utl.ifloor( max_hit * 1.1 )
	
	if "salve_e" in player.special_attributes and "undead" in target_mon.attributes:
			max_hit = Utl.ifloor( max_hit * 1.2 )
	elif "black_mask" in player.special_attributes:
		max_hit = Utl.ifloor( max_hit * 7.0/6 )
	elif "salve" in player.special_attributes and "undead" in target_mon.attributes:
		max_hit = Utl.ifloor( max_hit * 7.0/6 )
	
	if "berserk" in player.special_attributes:
		max_hit = Utl.ifloor( max_hit * 1.2 )
	
	if "vampyre" in target_mon.attributes:
		if "ivandis_flail" in player.special_attributes:
			max_hit = Utl.ifloor( max_hit * 1.2 )
		elif "blisterwood_flail" in player.special_attributes:
			max_hit = Utl.ifloor( max_hit * 1.25 )
		elif "blisterwood_sickle" in player.special_attributes:
			max_hit = Utl.ifloor( max_hit * 1.15 )
	if "viggora" in player.special_attributes:
		max_hit = Utl.ifloor( max_hit * 1.5 )
	if "keris" in player.special_attributes and "kalphite" in target_mon.attributes:
		max_hit = Utl.ifloor( max_hit * 4.0/3 )
	if "gadderhammer" in player.special_attributes and "shade" in target_mon.attributes:
		max_hit = Utl.ifloor( max_hit * 1.25 )
	if "demon" in target_mon.attributes:
		if "silverlight" in player.special_attributes:
			max_hit = Utl.ifloor( max_hit * 1.6 )
		elif "darklight" in player.special_attributes:
			max_hit = Utl.ifloor( max_hit * 1.6 )
		elif "arclight" in player.special_attributes:
			max_hit = Utl.ifloor( max_hit * 1.7 )
	if player.attack_style == "crush":
		if "inquisitor_1" in player.special_attributes:
			max_hit = Utl.ifloor( max_hit * 1.005 )
		elif "inquisitor_2" in player.special_attributes:
			max_hit = Utl.ifloor( max_hit * 1.01 )
		elif "inquisitor_3" in player.special_attributes:
			max_hit = Utl.ifloor( max_hit * 1.025 )
	if "dragonhunter_lance" in player.special_attributes && "dragon" in target_mon.attributes:
		max_hit = Utl.ifloor( max_hit * 1.2 )
	if "leaf_baxe" in player.special_attributes && "leafy" in target_mon.attributes:
		max_hit = Utl.ifloor( max_hit * 1.175 )
	if "barronite" in player.special_attributes && "golem" in target_mon.attributes:
		max_hit = Utl.ifloor( max_hit * 1.15 )
	
	if "dharok" in player.special_attributes:
		max_hit = Utl.ifloor( max_hit * ( 1 + ( player.hp_lvl - player.current_hp ) * player.hp_lvl * 0.0001 ) )
		
	p_max_hit = max_hit
	



func calc_p_hit_chance( player : player, target_mon : monster ):
	
	# Melee
	var eff_atk : int = Utl.ifloor( player.attack * player.prayer_atk ) + player.style_atk_bonus + 8
	
	# These should probably be in same order as in max hit
	if "void_melee" in player.special_attributes:
		eff_atk = Utl.ifloor( eff_atk * 1.1 )
	if "obsidian_armor" in player.special_attributes:
		eff_atk = Utl.ifloor( eff_atk * 1.1 )
	
	if "salve_e" in player.special_attributes and "undead" in target_mon.attributes:
			eff_atk = Utl.ifloor( eff_atk * 1.2 )
	elif "black_mask" in player.special_attributes:
		eff_atk = Utl.ifloor( eff_atk * 7.0/6 )
	elif "salve" in player.special_attributes and "undead" in target_mon.attributes:
		eff_atk = Utl.ifloor( eff_atk * 7.0/6 )
	
	if "vampyre" in target_mon.attributes:
		if "blisterwood_flail" in player.special_attributes:
			eff_atk = Utl.ifloor( eff_atk * 1.05 )
		elif "blisterwood_sickle" in player.special_attributes:
			eff_atk = Utl.ifloor( eff_atk * 1.05 )
	if "viggora" in player.special_attributes:
		eff_atk = Utl.ifloor( eff_atk * 1.5 )
	if "arclight" in player.special_attributes && "demon" in target_mon.attributes:
		eff_atk = Utl.ifloor( eff_atk * 1.7 )
	if player.attack_style == "crush":
		if "inquisitor_1" in player.special_attributes:
			eff_atk = Utl.ifloor( eff_atk * 1.005 )
		elif "inquisitor_2" in player.special_attributes:
			eff_atk = Utl.ifloor( eff_atk * 1.01 )
		elif "inquisitor_3" in player.special_attributes:
			eff_atk = Utl.ifloor( eff_atk * 1.025 )
	if "dragonhunter_lance" in player.special_attributes && "dragon" in target_mon.attributes:
		eff_atk = Utl.ifloor( eff_atk * 1.2 )
	if "leaf_baxe" in player.special_attributes && "leafy" in target_mon.attributes:
		eff_atk = Utl.ifloor( eff_atk * 1.175 )
	
	var atk_roll : int = eff_atk * ( player.atk_bonus + 64 )
	
	var def_roll : int = ( target_mon.defence_level + 9 ) * ( target_mon.style_def( player.attack_style ) + 64 )
	
	
	if atk_roll > def_roll:
		p_hit_chance = 1 - 0.5 * ( def_roll + 2.0 ) / ( atk_roll + 1.0 )
	else:
		p_hit_chance = 0.5 * atk_roll / ( def_roll + 1.0 )

func calc_m_hit_chance( player : player, target_mon : monster ):
	
	var atk_roll : int
	var def_roll : int
	
	if target_mon.attack_type.size() == 0:
		# Incomplete attack info
		m_hit_chance = 0
		return
	
	if target_mon.attack_type[0] == "magic":
		var eff_atk : int = target_mon.attack_level + 9
		atk_roll = eff_atk * ( target_mon.attack_magic  + 64 )
		
		# This may be wrong but nobody knows better
		var eff_def : int = Utl.ifloor( ( Utl.ifloor( player.defence * player.prayer_def ) + player.style_def_bonus ) * 0.3 )
		eff_def += Utl.ifloor( player.magic * player.prayer_magic * 0.7 ) + 8
		# Uhh... maybe
		eff_def = Utl.ifloor( eff_def * player.prayer_magic_def )
		
		def_roll = eff_def * ( player.style_def( "magic" ) + 64 )

	elif target_mon.attack_type[0] == "ranged":
		var eff_atk : int = target_mon.ranged_level + 8
		atk_roll = eff_atk * ( target_mon.attack_ranged  + 64 )
		
		var eff_def : int = Utl.ifloor( player.defence * player.prayer_def ) + player.style_def_bonus + 8
		def_roll = eff_def * ( player.style_def( "ranged" ) + 64 )
		
	else:
		# Melee
		var eff_atk : int = target_mon.attack_level + 8
		atk_roll = eff_atk * ( target_mon.attack_bonus  + 64 )
		
		var eff_def : int = Utl.ifloor( player.defence * player.prayer_def ) + player.style_def_bonus + 8
		def_roll = eff_def * ( player.style_def( target_mon.attack_type[0] ) + 64 )
		
		
	if atk_roll > def_roll:
		m_hit_chance = 1 - 0.5 * ( def_roll + 2 ) / ( atk_roll + 1 )
	else:
		m_hit_chance = 0.5 * atk_roll / ( def_roll + 1 )

func simulate_combat( player : player, target_mon : monster ):
	
	# Full tick accurate combat simulation
	var tick = 0
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var max_kill_duration : int = 2000 # ticks
	var keris : bool = "keris" in player.special_attributes
	var gaddehammer : bool = "gaddehammer" in player.special_attributes
	
	var simulated_kills = 10000
	
	if keris:
		for _kills in range(1, simulated_kills): # 100000 rounds
			var target_hp = target_mon.hitpoints
			while target_hp > 0:
				# Player attacks
				if rng.randf() < p_hit_chance:
					if rng.randi_range( 1, 51) == 1:
						target_hp -= rng.randi_range( 0, floor( p_max_hit * 3 ) )
					else:
						target_hp -= rng.randi_range( 0, p_max_hit)
				tick += player.attack_speed
			if _kills == 1 && tick >= max_kill_duration:
				print( "Too slow kills to simulate" )
				return
	elif gaddehammer:
		for _kills in range(1, simulated_kills): # 100000 rounds
			var target_hp = target_mon.hitpoints
			while target_hp > 0:
				# Player attacks
				if rng.randf() < p_hit_chance:
					if rng.randi_range( 1, 51) == 1:
						target_hp -= rng.randi_range( 0, floor( p_max_hit * 2 ) )
					else:
						target_hp -= rng.randi_range( 0, p_max_hit)
				tick += player.attack_speed
			if _kills == 1 && tick >= max_kill_duration:
				print( "Too slow kills to simulate" )
				return
	else:
		for _kills in range(1, simulated_kills): #1000 rounds
			var target_hp = target_mon.hitpoints
			while target_hp > 0:
				# Player attacks
				if rng.randf() < p_hit_chance:
					target_hp -= rng.randi_range( 0, p_max_hit)
				tick += player.attack_speed
			if _kills == 1 && tick >= max_kill_duration:
				print( "Too slow kills to simulate" )
				return
	
	p_dps2 = ( simulated_kills * target_mon.hitpoints ) / ( tick * 0.6 )
	time_to_kill2 =  ( tick * 0.6 ) / simulated_kills
	
	
