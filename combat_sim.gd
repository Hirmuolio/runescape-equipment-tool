extends Node


var p_max_hit : int	# Max hit with equipment specials
var base_max_hit : int	# Max hit without extra bonuses
var crit_max_hit : int	# Max hit with occasionally triggering specials

var p_hit_chance : float
var p_hit_roll : int
var p_def_roll : int
var p_dps : float
var p_dps2 : float
var time_to_kill : float
var time_to_kill2 : float

var m_max_hit : int
var m_hit_chance : float
var m_hit_roll : int
var m_def_roll : int
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
	
	if player.attack_stance == "magic":
		var spell : equipment = player.spell
		var max_hit : int
		
		if spell.item_name == "Slayer dart":
			if "slayer_task" in target_mon.attributes and "slayer_staff_e" in player.special_attributes:
				max_hit = int( player.magic / 6.0 ) + 10
			else:
				max_hit = int( player.magic / 10.0 ) + 10
			base_max_hit = max_hit
		else:
			max_hit = spell.magic_max_hit
			base_max_hit = max_hit
			
			if spell.bolt_spell && "chaos_gauntlet" in player.special_attributes: # TODO
				max_hit += 3
			if spell.god_spell && "charge" in player.special_attributes && player.cape.god_cape:
				max_hit += 10
		
		max_hit = int( max_hit * player.mag_dmg_bonus )
		
		
		if "elite_void_magic" in player.special_attributes:
				max_hit = int( max_hit * 1.025 )
		
		if "salve_ei" in player.special_attributes and "undead" in target_mon.attributes:
				max_hit = int( max_hit * 1.2 )
		elif "salve_i" in player.special_attributes and "undead" in target_mon.attributes:
			max_hit = int( max_hit * 1.15 ) # *1.16
		elif "black_mask_i" in player.special_attributes:
			max_hit = int( max_hit * 1.15 )
		
		if "tome_of_fire" in player.special_attributes && spell.element == "fire":
			max_hit = int( max_hit * 1.5 )
		if "tome_of_water" in player.special_attributes && spell.element == "water":
			max_hit = int( max_hit * 1.2 )
		if "somke_bass" in player.special_attributes && spell.book == "standard":
			max_hit = int( max_hit * 1.1 )
		
		if "thammaron" in player.special_attributes:
			max_hit = int( max_hit * 1.25 )
		
		
	elif player.attack_style == "ranged":
		var eff_str : int = int( player.ranged * player.prayer_rng ) + player.style_rng_bonus + 8
		
		base_max_hit = int(  0.5 + eff_str * ( player.rng_str_bonus + 64 ) / 640.0 )
		base_max_hit = int( base_max_hit * player.prayer_rng_str )
		
		p_max_hit = base_max_hit
		
		if "void_ranged" in player.special_attributes:
			p_max_hit = int( p_max_hit * 1.1 )
		elif "elite_void_ranged" in player.special_attributes:
				p_max_hit = int( p_max_hit * 1.125 )
		
		if "salve_ei" in player.special_attributes and "undead" in target_mon.attributes:
				p_max_hit = int( p_max_hit * 1.2 )
		elif "salve_i" in player.special_attributes and "undead" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 7.0/6 ) # *1.16
		elif "black_mask_i" in player.special_attributes:
			p_max_hit = int( p_max_hit * 1.15 )
		
		if "holy_water" in player.special_attributes and "demon" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 1 ) #unknown so lets not do anything
		
		if "dragonhunter_crossbow" in player.special_attributes and "dragon" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 1.25 )
		if "craw" in player.special_attributes:
			p_max_hit = int( p_max_hit * 1.5 )
		
		if "twisted" in player.special_attributes:
			var mag = max( target_mon.magic_level, target_mon.attack_magic )
			var mult = clamp( 0, 3 * mag - ( 3 * mag / 10.0 - 140 )^2, 2.5 )
			p_max_hit = int( p_max_hit * mult )
		
		
		crit_max_hit = p_max_hit
		if "opal_bolt_e" in player.special_attributes:
			crit_max_hit = int( player.ranged * 1.1 )
		if "pearl_bolt_e" in player.special_attributes:
			if "fiery" in target_mon.attributes:
				crit_max_hit += int( player.ranged / 15.0 )
			else:
				crit_max_hit += int( player.ranged / 20.0 )
		if "diamond_bolt_e" in player.special_attributes:
			crit_max_hit = int( crit_max_hit * 1.15 )
		if "dragonstone_bolt_e" in player.special_attributes and not ( "dragon" in target_mon.attributes ):
			crit_max_hit += int( crit_max_hit / 20.0 )
		if "onyx_bolt_e" in player.special_attributes:
			crit_max_hit = int( crit_max_hit * 1.2 )
		if "ruby_bolt_e" in player.special_attributes:
			crit_max_hit = max( crit_max_hit, int( min( target_mon.hitpoints * 1.2, 100) ) )
		
	else:
		# Melee
		var eff_str : int = int( player.strength * player.prayer_str ) + player.style_str_bonus + 8
		
		base_max_hit = int( 0.5 + eff_str * ( player.str_bonus + 64 ) / 640.0 )
		
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
		p_max_hit = base_max_hit
		if "void_melee" in player.special_attributes:
			p_max_hit = int( p_max_hit * 1.1 )
		if "obsidian_armor" in player.special_attributes:
			p_max_hit = int( p_max_hit * 1.1 )
		
		if "salve_e" in player.special_attributes and "undead" in target_mon.attributes:
				p_max_hit = int( p_max_hit * 1.2 )
		elif "black_mask" in player.special_attributes:
			p_max_hit = int( p_max_hit * 7.0/6 )
		elif "salve" in player.special_attributes and "undead" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 7.0/6 )
		
		if "berserk" in player.special_attributes:
			p_max_hit = int( p_max_hit * 1.2 )
		
		if "vampyre" in target_mon.attributes:
			if "ivandis_flail" in player.special_attributes:
				p_max_hit = int( p_max_hit * 1.2 )
			elif "blisterwood_flail" in player.special_attributes:
				p_max_hit = int( p_max_hit * 1.25 )
			elif "blisterwood_sickle" in player.special_attributes:
				p_max_hit = int( p_max_hit * 1.15 )
		if "viggora" in player.special_attributes:
			p_max_hit = int( p_max_hit * 1.5 )
		if "keris" in player.special_attributes and "kalphite" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 4.0/3 )
		if "gadderhammer" in player.special_attributes and "shade" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 1.25 )
		if "demon" in target_mon.attributes:
			if "silverlight" in player.special_attributes:
				p_max_hit = int( p_max_hit * 1.6 )
			elif "darklight" in player.special_attributes:
				p_max_hit = int( p_max_hit * 1.6 )
			elif "arclight" in player.special_attributes:
				p_max_hit = int( p_max_hit * 1.7 )
		if player.attack_style == "crush":
			if "inquisitor_1" in player.special_attributes:
				p_max_hit = int( p_max_hit * 1.005 )
			elif "inquisitor_2" in player.special_attributes:
				p_max_hit = int( p_max_hit * 1.01 )
			elif "inquisitor_3" in player.special_attributes:
				p_max_hit = int( p_max_hit * 1.025 )
		if "dragonhunter_lance" in player.special_attributes && "dragon" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 1.2 )
		if "leaf_baxe" in player.special_attributes && "leafy" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 1.175 )
		if "barronite" in player.special_attributes && "golem" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 1.15 )
		
		if "dharok" in player.special_attributes:
			p_max_hit = int( p_max_hit * ( 1 + ( player.hp_lvl - player.current_hp ) * player.hp_lvl * 0.0001 ) )
			
		crit_max_hit = p_max_hit
		
		if "keris" in player.special_attributes and "kalphite" in target_mon.attributes:
			crit_max_hit = p_max_hit * 3
		if "gadderhammer" in player.special_attributes and "shade" in target_mon.attributes:
			crit_max_hit = p_max_hit * 2
		
	



func calc_p_hit_chance( player : player, target_mon : monster ):
	
	var atk_roll : int
	var def_roll : int
	
	if player.attack_style == "ranged":
		var eff_atk : int = int( player.ranged * player.prayer_rng * player.prayer_rng_atk ) + player.style_rng_bonus + 8
		
		if "void_ranged" in player.special_attributes:
			eff_atk = int( eff_atk * 1.1 )
		
		if "salve_ei" in player.special_attributes and "undead" in target_mon.attributes:
				eff_atk = int( eff_atk * 1.2 )
		elif "salve_i" in player.special_attributes and "undead" in target_mon.attributes:
			eff_atk = int( eff_atk * 7.0/6 ) # *1.16
		elif "black_mask_i" in player.special_attributes:
			eff_atk = int( eff_atk * 1.15 )
		
		if "holy_water" in player.special_attributes and "demon" in target_mon.attributes:
			eff_atk = int( eff_atk * 1 ) #unknown so lets not do anything
		
		if "dragonhunter_crossbow" in player.special_attributes and "dragon" in target_mon.attributes:
			eff_atk = int( eff_atk * 1.3 )
		if "craw" in player.special_attributes:
			eff_atk = int( eff_atk * 1.5 )
		
		
		
		if "twisted" in player.special_attributes:
			var mag = max( target_mon.magic_level, target_mon.attack_magic )
			var mult = clamp( 0, 3 * mag - ( 3 * mag / 10.0 - 100 )^2 - 8.6, 1.4 )
			eff_atk = int( eff_atk * mult )
		
		atk_roll = eff_atk * ( player.rng_bonus + 64 )
		
		def_roll = ( target_mon.defence_level + 9 ) * ( target_mon.style_def( "ranged" ) + 64 )
	
	else:
		# Melee
		var eff_atk : int = int( player.attack * player.prayer_atk ) + player.style_atk_bonus + 8
		
		# These should probably be in same order as in max hit
		if "void_melee" in player.special_attributes:
			eff_atk = int( eff_atk * 1.1 )
		if "obsidian_armor" in player.special_attributes:
			eff_atk = int( eff_atk * 1.1 )
		
		if "salve_e" in player.special_attributes and "undead" in target_mon.attributes:
				eff_atk = int( eff_atk * 1.2 )
		elif "black_mask" in player.special_attributes:
			eff_atk = int( eff_atk * 7.0/6 )
		elif "salve" in player.special_attributes and "undead" in target_mon.attributes:
			eff_atk = int( eff_atk * 7.0/6 )
		
		if "vampyre" in target_mon.attributes:
			if "blisterwood_flail" in player.special_attributes:
				eff_atk = int( eff_atk * 1.05 )
			elif "blisterwood_sickle" in player.special_attributes:
				eff_atk = int( eff_atk * 1.05 )
		if "viggora" in player.special_attributes:
			eff_atk = int( eff_atk * 1.5 )
		if "arclight" in player.special_attributes && "demon" in target_mon.attributes:
			eff_atk = int( eff_atk * 1.7 )
		if player.attack_style == "crush":
			if "inquisitor_1" in player.special_attributes:
				eff_atk = int( eff_atk * 1.005 )
			elif "inquisitor_2" in player.special_attributes:
				eff_atk = int( eff_atk * 1.01 )
			elif "inquisitor_3" in player.special_attributes:
				eff_atk = int( eff_atk * 1.025 )
		if "dragonhunter_lance" in player.special_attributes && "dragon" in target_mon.attributes:
			eff_atk = int( eff_atk * 1.2 )
		if "leaf_baxe" in player.special_attributes && "leafy" in target_mon.attributes:
			eff_atk = int( eff_atk * 1.175 )
		
		atk_roll = eff_atk * ( player.atk_bonus + 64 )
		
		def_roll = ( target_mon.defence_level + 9 ) * ( target_mon.style_def( player.attack_style ) + 64 )
	
	p_hit_roll = atk_roll
	m_def_roll = def_roll
	
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
		var eff_def : int = int( ( int( player.defence * player.prayer_def ) + player.style_def_bonus ) * 0.3 )
		eff_def += int( player.magic * player.prayer_magic * 0.7 ) + 8
		# Uhh... maybe
		eff_def = int( eff_def * player.prayer_magic_def )
		
		def_roll = eff_def * ( player.style_def( "magic" ) + 64 )

	elif target_mon.attack_type[0] == "ranged":
		var eff_atk : int = target_mon.ranged_level + 8
		atk_roll = eff_atk * ( target_mon.attack_ranged  + 64 )
		
		var eff_def : int = int( player.defence * player.prayer_def ) + player.style_def_bonus + 8
		def_roll = eff_def * ( player.style_def( "ranged" ) + 64 )
		
	else:
		# Melee
		var eff_atk : int = target_mon.attack_level + 8
		atk_roll = eff_atk * ( target_mon.attack_bonus  + 64 )
		
		var eff_def : int = int( player.defence * player.prayer_def ) + player.style_def_bonus + 8
		def_roll = eff_def * ( player.style_def( target_mon.attack_type[0] ) + 64 )
	
	
	p_def_roll = def_roll
	m_hit_roll = atk_roll
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
	
	var crit_chance : float = 0
	if "keris" in player.special_attributes:
		crit_chance = 1.0/51
	elif "gaddehammer" in player.special_attributes:
		crit_chance = 1.0/51
	else:
		if "onyx_bolt_e" in player.special_attributes:
			crit_chance = 0.11
		if "dragonstone_bolt_e" in player.special_attributes and not ("dragon" in target_mon.attributes):
			crit_chance = 0.06
		if "diamond_bolt_e" in player.special_attributes:
			crit_chance = 0.1
		if "ruby_bolt_e" in player.special_attributes:
			crit_chance = 0.06
		if "pearl_bolt_e" in player.special_attributes:
			crit_chance = 0.06
		if "opal_bolt_e" in player.special_attributes:
			crit_chance = 0.05
		
		# This is a bit hacky but should not run when non-bolt crit is possible.
		var kandarin_hard : bool = false
		if kandarin_hard:
			crit_chance *= 1.1
		
	
	var simulated_kills = 10000
	
	if crit_chance > 0:
		if "ruby_bolt_e" in player.special_attributes:
			for _kills in range(1, simulated_kills):
				var target_hp = target_mon.hitpoints
				while target_hp > 0:
					# Player attacks
					if rng.randf() < p_hit_chance:
						if rng.randf() <= crit_chance:
							target_hp -= min( 100, int( target_mon.hitpoints * 0.2 ) )
						else:
							target_hp -= rng.randi_range( 0, p_max_hit)
					tick += player.attack_speed
				if _kills == 1 && tick >= max_kill_duration:
					print( "Too slow kills to simulate" )
					return
		if "diamond_bolt_e" in player.special_attributes:
			for _kills in range(1, simulated_kills):
				var target_hp = target_mon.hitpoints
				while target_hp > 0:
					# Player attacks
					if rng.randf() <= crit_chance:
						target_hp -= rng.randi_range( 0, crit_max_hit)
					elif rng.randf() < p_hit_chance:
						target_hp -= rng.randi_range( 0, p_max_hit)
					tick += player.attack_speed
				if _kills == 1 && tick >= max_kill_duration:
					print( "Too slow kills to simulate" )
					return
		else:
			for _kills in range(1, simulated_kills): # 100000 rounds
				var target_hp = target_mon.hitpoints
				while target_hp > 0:
					# Player attacks
					if rng.randf() < p_hit_chance:
						if rng.randf() <= crit_chance:
							target_hp -= rng.randi_range( 0, crit_max_hit )
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
	
	
