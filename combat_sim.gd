extends Node


var p_max_hit : int	# Max hit with equipment specials
var base_max_hit : int	# Max hit without extra bonuses
var crit_max_hit : int	# Max hit with occasionally triggering specials

var p_hit_chance : float
var p_hit_roll : int
var p_def_roll : int
var p_dps : float
var p_dps2 : float
var time_to_kill2 : float

var m_max_hit : int
var m_hit_chance : float
var m_hit_roll : int
var m_def_roll : int
var m_dps : float

# Special states set by the UI:

var charge_spell : bool = false
var kandarin_diary : bool = false
var wilderness : bool = true
var slayer_task : bool = true
var mark_of_darkness : bool = false
var dwh_specs : int = 0

signal simulation_done()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_slayer_value_changed(new_value):
	slayer_task = new_value
	do_fast_simulations()

func _on_charge_value_changed(new_value):
	charge_spell = new_value
	do_fast_simulations()

func _on_kandarin_value_changed(new_value):
	kandarin_diary = new_value
	do_fast_simulations()

func _on_wilderness_value_changed(new_value):
	wilderness = new_value
	do_fast_simulations()

func _on_darkness_value_changed(new_value):
	mark_of_darkness = new_value
	do_fast_simulations()

func _on_d_warammer_value_changed(new_value):
	dwh_specs = new_value
	do_fast_simulations()

func clear_results():
	p_max_hit = 0
	base_max_hit = 0
	crit_max_hit = 0
	
	p_hit_chance = 0
	p_hit_roll = 0
	p_def_roll = 0
	p_dps = 0
	p_dps2 = 0
	time_to_kill2 = 0
	
	m_max_hit = 0
	m_hit_chance = 0
	m_hit_roll = 0
	m_def_roll = 0
	m_dps = 0
	pass

func do_fast_simulations():
	var act_player = get_parent().get_node("player_data")
	var target_mon = get_parent().get_node("%monster_panel").current_monster
	
	clear_results()
	if !act_player:
		print( "NO PLAYER EXISTS")
		emit_signal("simulation_done")
		return
	if !target_mon:
		print( "NO TARGET MONSTER")
		emit_signal("simulation_done")
		return
	
	calc_p_max_hit( act_player, target_mon )
	calc_p_hit_chance( act_player, target_mon )
	
	p_dps = p_hit_chance * p_max_hit / 2 / act_player.attack_speed / 0.6
	if p_dps == 0:
		emit_signal("simulation_done")
		return
	
	calc_m_hit_chance( act_player, target_mon )
	m_max_hit = target_mon.max_hit
	if "bulwark" in act_player.special_attributes and act_player.attack_stance == "block":
		m_max_hit = m_max_hit * 4 / 5
	
	m_dps = m_hit_chance * m_max_hit / 2 / target_mon.attack_speed / 0.6
	
	emit_signal("simulation_done")

func do_simulations():
	var act_player = get_parent().get_node("player_data")
	var target_mon = get_parent().get_node("%monster_panel").current_monster
	
	clear_results()
	if !act_player:
		print( "NO PLAYER EXISTS")
		emit_signal("simulation_done")
		return
	if !target_mon:
		print( "NO TARGET MONSTER")
		emit_signal("simulation_done")
		return
	
	calc_p_max_hit( act_player, target_mon )
	calc_p_hit_chance( act_player, target_mon )
	
	p_dps = p_hit_chance * p_max_hit / 2 / act_player.attack_speed / 0.6
	if p_dps == 0:
		emit_signal("simulation_done")
		return
	
	calc_m_hit_chance( act_player, target_mon )
	m_max_hit = target_mon.max_hit
	
	m_dps = m_hit_chance * m_max_hit / 2 / target_mon.attack_speed / 0.6
	
	
	simulate_combat( act_player, target_mon )
	emit_signal("simulation_done")

func calc_p_max_hit( act_player : player, target_mon : monster ):
	
	var powered_staff : bool = "powered_staff" in act_player.special_attributes
	var magic_attack : bool = act_player.attack_stance == "magic" or powered_staff
	
	if magic_attack:
		var spell : equipment = act_player.spell
		
		var salamander : bool = "salamander" in act_player.weapon.item_name or act_player.weapon.item_name == "Swamp lizard"
		
		if salamander:
			var magic_str : int = 3
			if act_player.weapon.item_name == "Swamp lizard":
				magic_str = 56
			if act_player.weapon.item_name == "Orange salamander":
				magic_str = 59
			if act_player.weapon.item_name == "Red salamander":
				magic_str = 77
			if act_player.weapon.item_name == "Black salamander":
				magic_str = 92
			
			base_max_hit = (320 + act_player.magic * ( 64 + magic_str ) ) / 640
			p_max_hit = base_max_hit
		elif powered_staff:
			if act_player.weapon.item_name == "Starter staff":
				# Messy system for setting fire strike as attack
				spell = Database.get_node( "items/-4" )
				base_max_hit = 8
			elif act_player.weapon.item_name in ["Trident of the seas", "Trident of the seas (full)", "Trident of the seas (e)"]:
				base_max_hit = 20 + int( max( ( act_player.magic - 75 ) / 3, -19 ) )
			elif act_player.weapon.item_name in ["Trident of the swamp", "Trident of the swamp (e)"]:
				base_max_hit = 23 + int( max( ( act_player.magic - 75 ) / 3, -19 ) )
			elif act_player.weapon.item_name in ["Sanguinesti staff", "Holy sanguinesti staff"]:
				base_max_hit = 26 + int( max( ( act_player.magic - 82 ) / 3, -19 ) )
			elif act_player.weapon.item_name == "Dawnbringer":
				base_max_hit = 0 # No idea what the base damage is
			elif act_player.weapon.item_name == "Crystal staff (basic)":
				base_max_hit = 23
			elif act_player.weapon.item_name == "Crystal staff (attuned)":
				base_max_hit = 31
			elif act_player.weapon.item_name == "Crystal staff (perfected)":
				base_max_hit = 39
			p_max_hit = base_max_hit
		else:
			if !spell:
				return
			
			if spell.item_name == "Slayer dart":
				if slayer_task and "slayer_staff_e" in act_player.special_attributes:
					base_max_hit = int( act_player.magic / 6.0 ) + 10
				else:
					base_max_hit = int( act_player.magic / 10.0 ) + 10
			else:
				base_max_hit = spell.magic_max_hit
			
			p_max_hit = base_max_hit
			
			if "bolt" in spell.special_effects and "chaos_gauntlet" in act_player.special_attributes: # TODO
				p_max_hit += 3
			if "god_spell" in spell.special_effects and charge_spell and "god_cape" in act_player.special_attributes:
				p_max_hit += 10
		
		# This doesn't make sense but is supposedly "correct" (at least mostly)
		var multiplier : float = 1
		
		multiplier +=  act_player.mag_dmg_bonus / 100.0
		
		if spell and "somke_bass" in act_player.special_attributes and "standard" in spell.special_effects:
			multiplier += 0.1
		if "elite_void_magic" in act_player.special_attributes:
			multiplier += 0.025 
		
		var salve : bool = false
		if "salve_ei" in act_player.special_attributes and "undead" in target_mon.attributes:
			multiplier += 0.2
			salve = true
		elif "salve_i" in act_player.special_attributes and "undead" in target_mon.attributes:
			multiplier += 0.15
			salve = true
		
		p_max_hit = int( p_max_hit * multiplier )
		
		if spell and "tome_of_fire" in act_player.special_attributes && "fire" in spell.special_effects:
			p_max_hit = int( p_max_hit * 1.5 )
		if spell and "tome_of_water" in act_player.special_attributes && "water" in spell.special_effects:
			p_max_hit = int( p_max_hit * 1.2 )
		
		# This is weird and technically there could be a situation where taking off salve amulet
		# would give more dps. Not sure if that ever happens in practice.
		if slayer_task and !salve and "black_mask_i" in act_player.special_attributes:
			p_max_hit = int( p_max_hit * 1.15 )
		
		if wilderness and "thammaron" in act_player.special_attributes:
			p_max_hit = int( p_max_hit * 1.25 )
		
		if spell and mark_of_darkness and "demonbane" in spell.special_effects and "demon" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 1.25 )
		
		crit_max_hit = p_max_hit
		if "damned_ahrim" in act_player.special_attributes:
			crit_max_hit = int( crit_max_hit * 1.3 )
		
		
	elif act_player.attack_style == "ranged":
		var eff_str : int = int( act_player.ranged * act_player.prayer_rng ) + act_player.style_rng_bonus + 8
		
		if "void_ranged" in act_player.special_attributes:
			eff_str = int( eff_str * 1.1 )
		
		base_max_hit = int(  0.5 + eff_str * ( act_player.rng_str_bonus + 64 ) / 640.0 )
		base_max_hit = int( base_max_hit * act_player.prayer_rng_str )
		
		p_max_hit = base_max_hit
		
		
		if "elite_void_ranged" in act_player.special_attributes:
				p_max_hit = int( p_max_hit * 1.125 )
		
		if "salve_ei" in act_player.special_attributes and "undead" in target_mon.attributes:
				p_max_hit = int( p_max_hit * 1.2 )
		elif "salve_i" in act_player.special_attributes and "undead" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 7.0/6 ) # *1.16
		elif slayer_task and "black_mask_i" in act_player.special_attributes:
			p_max_hit = int( p_max_hit * 1.15 )
		
		if "holy_water" in act_player.special_attributes and "demon" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 1 ) #unknown so lets not do anything
		
		if "dragonhunter_crossbow" in act_player.special_attributes and "dragon" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 1.25 )
		if wilderness and "craw" in act_player.special_attributes:
			p_max_hit = int( p_max_hit * 1.5 )
		
		crit_max_hit = p_max_hit
		if "opal_bolt_e" in act_player.special_attributes:
			crit_max_hit = p_max_hit + int( act_player.ranged * 0.1 )
		if "pearl_bolt_e" in act_player.special_attributes:
			if "fiery" in target_mon.attributes:
				crit_max_hit += int( act_player.ranged / 15.0 )
			else:
				crit_max_hit += int( act_player.ranged / 20.0 )
		if "diamond_bolt_e" in act_player.special_attributes:
			crit_max_hit = int( crit_max_hit * 1.15 )
		if "dragonstone_bolt_e" in act_player.special_attributes and not ( "dragon" in target_mon.attributes ):
			crit_max_hit += int( crit_max_hit / 20.0 )
		if "onyx_bolt_e" in act_player.special_attributes:
			crit_max_hit = int( crit_max_hit * 1.2 )
		if "ruby_bolt_e" in act_player.special_attributes:
			crit_max_hit = int( max( crit_max_hit, int( min( target_mon.hitpoints * 1.2, 100) ) ) )
		
		if "twisted" in act_player.special_attributes:
			var mag : int = int( max( target_mon.magic_level, target_mon.attack_magic ) )
			var mult_1 : int = ( 10*3*mag / 10 - 14 ) / 100
			var mult_2 : int = ( 3*mag/10 - 100 )*( 3*mag/10 - 140 )/100
			var percent : int = int( clamp( 250 + mult_1 - mult_2, 0, 250 ) )
			p_max_hit = p_max_hit * percent / 100
		
	else:
		# Melee
		var eff_str : int = int( act_player.strength * act_player.prayer_str ) + act_player.style_str_bonus + 8
		
		if "void_melee" in act_player.special_attributes:
			eff_str = int( eff_str * 1.1 )
		
		var eq_str : int = act_player.str_bonus
		
		if "bulwark" in act_player.special_attributes and act_player.attack_stance == "accurate":
			#get_equipment_bonus( "defence_stab" )
			var total_def : int = act_player.get_equipment_bonus( "defence_stab" ) + act_player.get_equipment_bonus( "defence_slash" ) + act_player.get_equipment_bonus( "defence_crush" ) + act_player.get_equipment_bonus( "defence_ranged" )
			# I do not know if these should be done as integer division or not
			# I do them as integer divisions
			eq_str += ( total_def / 4 - 200 ) / 3 - 38
		
		base_max_hit = int( 0.5 + eff_str * ( eq_str + 64 ) / 640.0 )
		
		
		# Special bonuses need to be applied in specific order
		#Order:
		# Obsidian armor before salve (e)
		# Obsidian armor before berserker necklace
		# Black mask before berserker necklace
		# Black mask before special attack
		# Others ???
		p_max_hit = base_max_hit
		crit_max_hit = p_max_hit
		
		
		if "obsidian_armor" in act_player.special_attributes:
			p_max_hit = int( p_max_hit * 1.1 )
		
		
		
		if "salve_e" in act_player.special_attributes and "undead" in target_mon.attributes:
				p_max_hit = int( p_max_hit * 1.2 )
		elif slayer_task and "black_mask" in act_player.special_attributes:
			p_max_hit = int( p_max_hit * 7.0/6 )
		elif "salve" in act_player.special_attributes and "undead" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 7.0/6 )
		
		if "berserk" in act_player.special_attributes:
			p_max_hit = int( p_max_hit * 1.2 )
		
		if "vampyre" in target_mon.attributes:
			if "ivandis_flail" in act_player.special_attributes:
				p_max_hit = int( p_max_hit * 1.2 )
			elif "blisterwood_flail" in act_player.special_attributes:
				p_max_hit = int( p_max_hit * 1.25 )
			elif "blisterwood_sickle" in act_player.special_attributes:
				p_max_hit = int( p_max_hit * 1.15 )
		if "keris" in act_player.special_attributes and ( "kalphite" in target_mon.attributes or "scabarite"  in target_mon.attributes ):
			crit_max_hit = p_max_hit * 3 # I think the crit is without the 33%
			p_max_hit = int( p_max_hit * 4.0/3 )
		if "gadderhammer" in act_player.special_attributes and "shade" in target_mon.attributes:
			crit_max_hit = p_max_hit * 2
			p_max_hit = int( p_max_hit * 1.25 )
		if "demon" in target_mon.attributes:
			if "silverlight" in act_player.special_attributes:
				p_max_hit = int( p_max_hit * 1.6 )
			elif "darklight" in act_player.special_attributes:
				p_max_hit = int( p_max_hit * 1.6 )
			elif "arclight" in act_player.special_attributes:
				p_max_hit = int( p_max_hit * 1.7 )
		if act_player.attack_style == "crush":
			if "inquisitor_1" in act_player.special_attributes:
				p_max_hit = int( p_max_hit * 1.005 )
			elif "inquisitor_2" in act_player.special_attributes:
				p_max_hit = int( p_max_hit * 1.01 )
			elif "inquisitor_3" in act_player.special_attributes:
				p_max_hit = int( p_max_hit * 1.025 )
		if "dragonhunter_lance" in act_player.special_attributes && "dragon" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 1.2 )
		if "leaf_baxe" in act_player.special_attributes && "leafy" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 1.175 )
		if "barronite" in act_player.special_attributes && "golem" in target_mon.attributes:
			p_max_hit = int( p_max_hit * 1.15 )
		if wilderness and "viggora" in act_player.special_attributes:
			p_max_hit = int( p_max_hit * 1.5 )
		
		if "dharok" in act_player.special_attributes:
			p_max_hit = int( p_max_hit * ( 1 + ( act_player.hp_lvl - act_player.current_hp ) * act_player.hp_lvl * 0.0001 ) )
		if "verac" in act_player.special_attributes:
			crit_max_hit += 1
		
		



func calc_p_hit_chance( act_player : player, target_mon : monster ):
	
	# Math mostly based on wiki
	# I do not trust this math at all
	
	var atk_roll : int
	var def_roll : int
	
	var powered_staff : bool = "powered_staff" in act_player.special_attributes
	var magic_attack : bool = act_player.attack_stance == "magic" or powered_staff
	
	if magic_attack:
		var eff_atk : int = int( act_player.magic * act_player.prayer_magic )
		eff_atk = int( eff_atk * act_player.prayer_magic_atk )
		
		if "void_magic" in act_player.special_attributes:
			eff_atk = int( eff_atk * 1.45 )
		
		eff_atk += act_player.style_mag_bonus + 9
		atk_roll = eff_atk * ( act_player.magic_bonus + 64 )
		
		if "salve_ei" in act_player.special_attributes and "undead" in target_mon.attributes:
			atk_roll = int( atk_roll * 1.2 )
		elif "salve_i" in act_player.special_attributes and "undead" in target_mon.attributes:
			atk_roll = int( atk_roll * 7.0/6 ) # *1.16
		elif slayer_task and "black_mask_i" in act_player.special_attributes:
			atk_roll = int( atk_roll * 1.15 )
		
		if "tome_of_water" in act_player.special_attributes && "water" in act_player.spell.special_effects:
			atk_roll = int( atk_roll * 1.2 )
		if "somke_bass" in act_player.special_attributes:
			atk_roll = int( atk_roll * 1.1 )
		if wilderness and "thammaron" in act_player.special_attributes:
			atk_roll = int( atk_roll * 2 )
		
		if act_player.spell and "demonbane" in act_player.spell.special_effects and "demon" in target_mon.attributes:
			if mark_of_darkness: 
				atk_roll = int( atk_roll * 1.4 )
			else:
				atk_roll = int( atk_roll * 1.2 )
		
		def_roll = ( target_mon.magic_level + 9 ) * ( target_mon.style_def( "magic" ) + 64 )
		
		
		
	elif act_player.attack_style == "ranged":
		var eff_atk : int = int( act_player.ranged * act_player.prayer_rng * act_player.prayer_rng_atk ) + act_player.style_rng_bonus + 8
		
		if "void_ranged" in act_player.special_attributes:
			eff_atk = int( eff_atk * 1.1 )
		
		atk_roll = eff_atk * ( act_player.rng_bonus + 64 )
		
		if "salve_ei" in act_player.special_attributes and "undead" in target_mon.attributes:
			atk_roll = int( atk_roll * 1.2 )
		elif "salve_i" in act_player.special_attributes and "undead" in target_mon.attributes:
			atk_roll = int( atk_roll * 7.0/6 ) # *1.16
		elif slayer_task and "black_mask_i" in act_player.special_attributes:
			atk_roll = int( atk_roll * 1.15 )
		
		if "holy_water" in act_player.special_attributes and "demon" in target_mon.attributes:
			atk_roll = int( atk_roll * 1 ) #unknown so lets not do anything
		
		if "dragonhunter_crossbow" in act_player.special_attributes and "dragon" in target_mon.attributes:
			atk_roll = int( atk_roll * 1.3 )
		if wilderness and "craw" in act_player.special_attributes:
			atk_roll = int( atk_roll * 1.5 )
		
		
		
		if "twisted" in act_player.special_attributes:
			var mag : int = int( max( target_mon.magic_level, target_mon.attack_magic ) )
			var mult_1 : int = ( 10*3*mag / 10 - 10 ) / 100
			var mult_2 : int = ( 3*mag/10 - 100 )*( 3*mag/10 - 100 )/100
			var percent : int = int( clamp( 140 + mult_1 - mult_2, 0, 140 ) )
			atk_roll = atk_roll * percent / 100
		
		var monster_def_lvl : int = target_mon.defence_level
		if dwh_specs > 0:
			for _i in range(dwh_specs):
				monster_def_lvl = monster_def_lvl * 7 / 10
		def_roll = ( monster_def_lvl + 9 ) * ( target_mon.style_def( "ranged" ) + 64 )
	
	else:
		# Melee
		var eff_atk : int = int( act_player.attack * act_player.prayer_atk ) + act_player.style_atk_bonus + 8
		
		# These should probably be in same order as in max hit
		if "void_melee" in act_player.special_attributes:
			eff_atk = int( eff_atk * 1.1 )
		
		atk_roll = eff_atk * ( act_player.atk_bonus + 64 )
		
		if "obsidian_armor" in act_player.special_attributes:
			atk_roll = int( atk_roll * 1.1 )
		
		if "salve_e" in act_player.special_attributes and "undead" in target_mon.attributes:
			atk_roll = int( atk_roll * 1.2 )
		elif slayer_task and "black_mask" in act_player.special_attributes:
			atk_roll = int( atk_roll * 7.0/6 )
		elif "salve" in act_player.special_attributes and "undead" in target_mon.attributes:
			atk_roll = int( atk_roll * 7.0/6 )
		
		if "vampyre" in target_mon.attributes:
			if "blisterwood_flail" in act_player.special_attributes:
				atk_roll = int( atk_roll * 1.05 )
			elif "blisterwood_sickle" in act_player.special_attributes:
				atk_roll = int( atk_roll * 1.05 )
		if wilderness and "viggora" in act_player.special_attributes:
			atk_roll = int( atk_roll * 1.5 )
		if "arclight" in act_player.special_attributes && "demon" in target_mon.attributes:
			atk_roll = int( atk_roll * 1.7 )
		if act_player.attack_style == "crush":
			if "inquisitor_1" in act_player.special_attributes:
				atk_roll = int( atk_roll * 1.005 )
			elif "inquisitor_2" in act_player.special_attributes:
				atk_roll = int( atk_roll * 1.01 )
			elif "inquisitor_3" in act_player.special_attributes:
				atk_roll = int( atk_roll * 1.025 )
		if "dragonhunter_lance" in act_player.special_attributes && "dragon" in target_mon.attributes:
			atk_roll = int( atk_roll * 1.2 )
		if "leaf_baxe" in act_player.special_attributes && "leafy" in target_mon.attributes:
			atk_roll = int( atk_roll * 1.175 )
		
		var monster_def_lvl : int = target_mon.defence_level
		if dwh_specs > 0:
			for _i in range(dwh_specs):
				monster_def_lvl = monster_def_lvl * 7 / 10
		
		def_roll = ( monster_def_lvl + 9 ) * ( target_mon.style_def( act_player.attack_style ) + 64 )
	
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
		var eff_atk : int = target_mon.magic_level + 9
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
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	
	
	var crit_chance : float = 0
	if "keris" in player.special_attributes:
		crit_chance = 1.0/51
	elif "gaddehammer" in player.special_attributes:
		crit_chance = 1.0/51
	elif "damned_ahrim" in player.special_attributes:
		crit_chance = 0.25
	elif "damned_karil" in player.special_attributes:
		crit_chance = 0.25
	elif "verac" in player.special_attributes:
		crit_chance = 0.25
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
		if kandarin_diary:
			crit_chance *= 1.1
		
	
	var simulated_kills : int = 10000
	var max_kill_duration : int = 2000 # ticks
	var tick : int = 0
	
	if crit_chance > 0:
		if "ruby_bolt_e" in player.special_attributes:
			for _kills in range(1, simulated_kills):
				var target_hp : int = target_mon.hitpoints
				while target_hp > 0:
					# Player attacks
					if rng.randf() < p_hit_chance:
						if rng.randf() <= crit_chance:
							target_hp -= int( min( 100, int( target_mon.hitpoints * 0.2 ) ) )
						else:
							target_hp -= rng.randi_range( 0, p_max_hit)
					tick += player.attack_speed
				if _kills == 1 && tick >= max_kill_duration:
					print( "Too slow kills to simulate" )
					return
		elif "diamond_bolt_e" in player.special_attributes:
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
		elif "damned_karil" in player.special_attributes:
			for _kills in range(1, simulated_kills):
				var target_hp = target_mon.hitpoints
				while target_hp > 0:
					# Player attacks
					if rng.randf() < p_hit_chance:
						target_hp -= rng.randi_range( 0, p_max_hit)
					if rng.randf() <= crit_chance && rng.randf() < p_hit_chance:
						target_hp -= rng.randi_range( 0, int( p_max_hit * 0.5 ) )
					tick += player.attack_speed
				if _kills == 1 && tick >= max_kill_duration:
					print( "Too slow kills to simulate" )
					return
		elif "verac" in player.special_attributes:
			for _kills in range(1, simulated_kills):
				var target_hp = target_mon.hitpoints
				while target_hp > 0:
					# Player attacks
					if rng.randf() < crit_chance:
						target_hp -= rng.randi_range( 0, p_max_hit)
					elif rng.randf() < p_hit_chance:
						target_hp -= rng.randi_range( 0, p_max_hit) + 1
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
	elif "scythe_vitur" in player.special_attributes and int(target_mon.size) > 1:
		for _kills in range(1, simulated_kills): #1000 rounds
			var target_hp = target_mon.hitpoints
			while target_hp > 0:
				# Player attacks
				if rng.randf() < p_hit_chance:
					target_hp -= rng.randi_range( 0, p_max_hit )
				if rng.randf() < p_hit_chance:
					target_hp -= rng.randi_range( 0, int( p_max_hit * 0.5 ) )
				if rng.randf() < p_hit_chance:
					target_hp -= rng.randi_range( 0, int( p_max_hit * 0.25 ) )
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
	
	


















