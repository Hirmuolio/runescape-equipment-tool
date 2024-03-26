extends Node

var act_player : player # Generally speaking this does not change
var target_mon : monster

# Special states set by the UI:
var charge_spell : bool = false
var kandarin_diary : bool = false
var wilderness : bool = true
var slayer_task : bool = true
var mark_of_darkness : bool = false
var dwh_specs : int = 0
var toa : bool = false
var toa_multiplier : float = 1
var toa_damage_multiplier : float = 1

signal simulation_done( dps : dps_stats )

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_slayer_value_changed(new_value : bool) -> void:
	slayer_task = new_value
	do_fast_simulations()

func _on_charge_value_changed(new_value : bool) -> void:
	charge_spell = new_value
	do_fast_simulations()

func _on_kandarin_value_changed(new_value : bool) -> void:
	kandarin_diary = new_value
	do_fast_simulations()

func _on_wilderness_value_changed(new_value : bool) -> void:
	wilderness = new_value
	do_fast_simulations()

func _on_darkness_value_changed(new_value : bool) -> void:
	mark_of_darkness = new_value
	do_fast_simulations()

func _on_d_warammer_value_changed(new_value : bool) -> void:
	dwh_specs = new_value
	do_fast_simulations()

func _on_toa_value_changed(new_value : bool) -> void:
	toa = new_value
	do_fast_simulations()

func _on_toa_level_value_changed(new_value : int) -> void:
	toa_damage_multiplier = min( 1.5, 1 + new_value * 0.02 )
	toa_multiplier = 1 + new_value * 0.02
	# TODO update npc stats
	do_fast_simulations()

func do_fast_simulations() -> void:
	do_simulations( false )

func do_simulations( full_sim : bool = false ) -> dps_stats:
	var stats : dps_stats = preload("res://resources/dps_stats.gd").new()
	
	# Ignore if things are not set
	if act_player == null:
		return stats
	if act_player.attack_stance == null:
		return stats
	
	
	if !act_player:
		print( "NO PLAYER EXISTS")
		simulation_done.emit(stats)
		return
	if !target_mon:
		print( "NO TARGET MONSTER")
		simulation_done.emit(stats)
		return
	
	set_p_max_hit( stats )
	
	stats.monster_def_roll = calc_monster_def_roll()
	stats.player_atk_roll = calc_player_atk_roll()
	var osmumten : bool = "osmumten" in act_player.special_attributes
	stats.hit_chance = calc_hit_chance( stats.player_atk_roll, stats.monster_def_roll, osmumten )
	
	stats.dps = stats.hit_chance * stats.max_hit / 2.0 / act_player.attack_speed / 0.6
	if stats.dps == 0:
		simulation_done.emit(stats)
		return
	
	stats.player_def_roll = calc_player_def_roll()
	stats.monster_atk_roll = calc_monster_atk_roll()
	stats.monster_hit_chance = calc_hit_chance( stats.monster_atk_roll, stats.player_def_roll, false )
	
	stats.monster_max_hit = int( target_mon.max_hit * toa_damage_multiplier )
	if "bulwark" in act_player.special_attributes and act_player.attack_stance.is_block():
		stats.monster_max_hit = stats.monster_max_hit * 4 / 5
	
	stats.monster_dps = stats.monster_hit_chance * stats.monster_max_hit / 2.0 / target_mon.attack_speed / 0.6
	
	if full_sim:
		simulate_combat( stats )
	simulation_done.emit(stats)
	return stats

func set_p_max_hit(  stats : dps_stats ) -> void:
	
	var powered_staff : bool = "powered_staff" in act_player.special_attributes
	
	var max_hit : int = 0
	var crit_max_hit : int = 0
	
	if act_player.attack_stance.is_magic():
		var spell : equipment = act_player.spell
		
		var salamander : bool = act_player.weapon and ( "salamander" in act_player.weapon.item_name or act_player.weapon.item_name == "Swamp lizard" )
		
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
			if act_player.weapon.item_name == "Tecu salamander":
				magic_str = 104
			
			max_hit = (320 + act_player.magic * ( 64 + magic_str ) ) / 640
		elif powered_staff:
			if act_player.weapon.item_name == "Starter staff":
				# Messy system for setting fire strike as attack
				spell = Database.get_node( "items/-4" )
				max_hit = 8
			elif act_player.weapon.item_name in ["Trident of the seas", "Trident of the seas (full)", "Trident of the seas (e)"]:
				max_hit = 20 + int( max( ( act_player.magic - 75 ) / 3, -19 ) )
			elif act_player.weapon.item_name in ["Trident of the swamp", "Trident of the swamp (e)"]:
				max_hit = 23 + int( max( ( act_player.magic - 75 ) / 3, -19 ) )
			elif act_player.weapon.item_name in ["Sanguinesti staff", "Holy sanguinesti staff"]:
				max_hit = 26 + int( max( ( act_player.magic - 82 ) / 3, -19 ) )
			elif "tumekens_shadow" in act_player.special_attributes:
				max_hit = act_player.magic / 3 + 1
			elif act_player.weapon.item_name == "Dawnbringer":
				max_hit = 0 # No idea what the base damage is
			elif act_player.weapon.item_name == "Crystal staff (basic)":
				max_hit = 23
			elif act_player.weapon.item_name == "Crystal staff (attuned)":
				max_hit = 31
			elif act_player.weapon.item_name == "Crystal staff (perfected)":
				max_hit = 39
		else:
			if !spell:
				return
			
			if spell.item_name == "Magic dart":
				if slayer_task and "slayer_staff_e" in act_player.special_attributes:
					max_hit = act_player.magic / 6 + 13
				else:
					max_hit = act_player.magic / 10 + 10
			else:
				max_hit = spell.magic_max_hit
			
			if "bolt" in spell.special_effects and "chaos_gauntlet" in act_player.special_attributes: # TODO
				max_hit += 3
			if "god_spell" in spell.special_effects and charge_spell and "god_cape" in act_player.special_attributes:
				max_hit += 10
		
		# Magic damage multiplier calculations
		# 1. Sum additive bonuses together
		# 2. Apply total additive bonus
		# 3. Apply multiplicative bonuses in specific order
		# 4. Calculate damage (roll random number)
		# 5. Apply post-roll modifiers (tomes)
		
		# TODO write in integer math
		var multiplier : float = 1
		
		if "tumekens_shadow" in act_player.special_attributes:
			multiplier +=  act_player.mag_dmg_bonus * 3 / 100.0
		else:
			multiplier +=  act_player.mag_dmg_bonus / 100.0
		
		if spell and "somke_bass" in act_player.special_attributes and "standard" in spell.special_effects:
			multiplier += 0.1
		if "elite_void_magic" in act_player.special_attributes:
			multiplier += 0.025 
		
		# Salve overrides slayer helm
		var salve : bool = false
		if "salve_ei" in act_player.special_attributes and "undead" in target_mon.attributes:
			multiplier += 0.2
			salve = true
		elif "salve_i" in act_player.special_attributes and "undead" in target_mon.attributes:
			multiplier += 0.15
			salve = true
		
		max_hit = int( max_hit * multiplier )
		
		# Multipliers must be applied in specific order.
		# This order is not fully known
		# Slayer helm before tome of fire
		# TODO: Write in integer math
		multiplier = 1
		
		if !salve and slayer_task and "black_mask_i" in act_player.special_attributes:
			#p_max_hit = p_max_hit * 23/20 # 15%
			multiplier += 0.15
		if wilderness and "thammaron" in act_player.special_attributes:
			#p_max_hit = p_max_hit * 5/4
			multiplier += 0.25
		if "damned_ahrim" in act_player.special_attributes:
			#crit_max_hit = crit_max_hit * 13/10 # 30%
			crit_max_hit = int( max_hit * ( multiplier + 0.3 )  )
		else:
			crit_max_hit = int( max_hit * multiplier )
		
		max_hit = int( max_hit * multiplier )
		#state.p_crit_max_hit = crit_max_hit
		
		# These three appear to applied after max hit is rolled.
		if spell and "tome_of_fire" in act_player.special_attributes && "fire" in spell.special_effects:
			stats.post_roll_mult = Vector2i(3,2)
		if spell and "tome_of_water" in act_player.special_attributes && "water" in spell.special_effects:
			stats.post_roll_mult = Vector2i(6,5)
		if spell and mark_of_darkness and "demonbane" in spell.special_effects and "demon" in target_mon.attributes:
			stats.post_roll_mult = Vector2i(5,4)
	
	elif act_player.attack_stance.is_ranged():
		var eff_str : int = int( act_player.ranged * act_player.prayer_rng ) + act_player.style_rng_bonus + 8
		
		if "void_ranged" in act_player.special_attributes:
			eff_str = eff_str * 11/10
		
		# Feels wrong to have floats here
		# TODO rewrite to integer math
		max_hit = int(  0.5 + eff_str * ( act_player.rng_str_bonus + 64 ) / 640.0 )
		max_hit = int( max_hit * act_player.prayer_rng_str )
		
		if "elite_void_ranged" in act_player.special_attributes:
				max_hit = max_hit * 9/8
		
		if "salve_ei" in act_player.special_attributes and "undead" in target_mon.attributes:
				max_hit = max_hit * 6/5
		elif "salve_i" in act_player.special_attributes and "undead" in target_mon.attributes:
			max_hit = max_hit * 7/6 # *1.16
		elif slayer_task and "black_mask_i" in act_player.special_attributes:
			max_hit = max_hit * 23/20 # 15%
		
		if "holy_water" in act_player.special_attributes and "demon" in target_mon.attributes:
			max_hit = max_hit * 8/5
		
		if "dragonhunter_crossbow" in act_player.special_attributes and "dragon" in target_mon.attributes:
			max_hit = max_hit * 5/4
		if wilderness and "craw" in act_player.special_attributes:
			max_hit = max_hit * 3/2
		
		var zaryte : bool = "zaryte_xbow" in act_player.special_attributes
		
		# Critical comes from various enchanted bolts
		crit_max_hit = max_hit
		
		if "opal_bolt_e" in act_player.special_attributes:
			if zaryte:
				crit_max_hit += act_player.ranged / 9
			else:
				crit_max_hit += act_player.ranged / 10
		if "pearl_bolt_e" in act_player.special_attributes:
			if "fiery" in target_mon.attributes:
				if zaryte:
					crit_max_hit += act_player.ranged / 14 # Not sure about this
				else:
					crit_max_hit += act_player.ranged / 15
			else:
				if zaryte:
					crit_max_hit += act_player.ranged / 18 # Not sure about this
				else:
					crit_max_hit += act_player.ranged / 20
		if "diamond_bolt_e" in act_player.special_attributes:
			if zaryte:
				crit_max_hit = crit_max_hit * 5/4
			else:
				crit_max_hit = crit_max_hit * 23/20
		if "dragonstone_bolt_e" in act_player.special_attributes and not ( "dragon" in target_mon.attributes ):
			if zaryte:
				crit_max_hit += act_player.ranged * 61/50
			else:
				crit_max_hit += act_player.ranged * 6/5
		if "onyx_bolt_e" in act_player.special_attributes:
			if zaryte:
				crit_max_hit = crit_max_hit * 13/10
			else:
				crit_max_hit = crit_max_hit * 12/10
		if "ruby_bolt_e" in act_player.special_attributes:
			if zaryte:
				crit_max_hit = int( max( crit_max_hit, int( min( target_mon.hitpoints * 1.22, 110) ) ) )
			else:
				crit_max_hit = int( max( crit_max_hit, int( min( target_mon.hitpoints * 6/5, 100) ) ) )
		
		if "twisted" in act_player.special_attributes:
			var mag : int = int( max( target_mon.magic_level, target_mon.attack_magic ) )
			var mult_1 : int = ( 10*3*mag / 10 - 14 ) / 100
			var mult_2 : int = ( 3*mag/10 - 100 )*( 3*mag/10 - 140 )/100
			var percent : int = int( clamp( 250 + mult_1 - mult_2, 0, 250 ) )
			max_hit = max_hit * percent / 100
		
		if "crystal_bow" in act_player.special_attributes:
			var damage_mult : float = 1
			if "carystal_body" in act_player.special_attributes:
				damage_mult += 0.075
			if "crystal_legs" in act_player.special_attributes:
				damage_mult += 0.05
			if "crystal_helm" in act_player.special_attributes:
				damage_mult += 0.025
			max_hit = int( damage_mult * max_hit)
	
	else:
		# Melee
		var eff_str : int = int( act_player.strength * act_player.prayer_str ) + act_player.style_str_bonus + 8
		
		if "void_melee" in act_player.special_attributes:
			eff_str = eff_str * 11/10
		
		var eq_str : int = act_player.str_bonus
		
		if "bulwark" in act_player.special_attributes and !act_player.attack_stance.is_block():
			#get_equipment_bonus( "defence_stab" )
			var total_def : int = act_player.get_equipment_bonus( "defence_stab" ) + act_player.get_equipment_bonus( "defence_slash" ) + act_player.get_equipment_bonus( "defence_crush" ) + act_player.get_equipment_bonus( "defence_ranged" )
			eq_str += ( total_def / 4 - 200 ) / 3 - 38
		
		# Having floats here feels wrong
		max_hit = int( 0.5 + eff_str * ( eq_str + 64 ) / 640.0 )
		
		
		# Special bonuses need to be applied in specific order
		#Order:
		# Keris (partisan) before slayer helm
		# Obsidian armor before salve (e)
		# Obsidian armor before berserker necklace
		# Black mask before berserker necklace
		# Black mask before special attack
		# Salve before dharok
		# Others ???
		
		# Critical hit comes from keris (kalphite), gadderhammer (ghast) and verac (set)
		crit_max_hit = max_hit
		
		
		if "obsidian_armor" in act_player.special_attributes:
			max_hit =  max_hit * 11/10
		
		if "keris" in act_player.special_attributes and ( "kalphite" in target_mon.attributes or "scabarite"  in target_mon.attributes ):
			max_hit = max_hit * 4/3
			crit_max_hit = max_hit * 3 # I think the is with the 33% included
		
		if "salve_e" in act_player.special_attributes and "undead" in target_mon.attributes:
			max_hit = max_hit * 6/5
			crit_max_hit = crit_max_hit * 6/5
		elif slayer_task and "black_mask" in act_player.special_attributes:
			max_hit = max_hit * 7/6
			crit_max_hit = crit_max_hit * 7/6
		elif "salve" in act_player.special_attributes and "undead" in target_mon.attributes:
			max_hit = max_hit * 7/6
			crit_max_hit = crit_max_hit * 7/6
		if "berserk" in act_player.special_attributes:
			max_hit = max_hit * 6/5
		
		if "vampyre" in target_mon.attributes:
			if "ivandis_flail" in act_player.special_attributes:
				max_hit = max_hit * 6/5
			elif "blisterwood_flail" in act_player.special_attributes:
				max_hit = max_hit * 5/4
			elif "blisterwood_sickle" in act_player.special_attributes:
				max_hit = max_hit * 23/20
		if "gadderhammer" in act_player.special_attributes and "shade" in target_mon.attributes:
			# IDK if the critical also includes the normal bonus
			crit_max_hit = max_hit * 2
			max_hit = max_hit * 5/4
		if "demon" in target_mon.attributes:
			if "silverlight" in act_player.special_attributes:
				max_hit = max_hit * 8/5
			elif "darklight" in act_player.special_attributes:
				max_hit = max_hit * 33/20
			elif "arclight" in act_player.special_attributes:
				max_hit = max_hit * 17/10
		if act_player.attack_stance.is_crush():
			if "inquisitor_1" in act_player.special_attributes:
				max_hit = int( max_hit * 1.005 )
			elif "inquisitor_2" in act_player.special_attributes:
				max_hit = int( max_hit * 1.01 )
			elif "inquisitor_3" in act_player.special_attributes:
				max_hit = int( max_hit * 1.025 )
		if "dragonhunter_lance" in act_player.special_attributes && "dragon" in target_mon.attributes:
			max_hit = max_hit * 6/5
		if "leaf_baxe" in act_player.special_attributes && "leafy" in target_mon.attributes:
			max_hit =  max_hit * 47/40
		if "barronite" in act_player.special_attributes && "golem" in target_mon.attributes:
			max_hit = max_hit * 23/20
		if wilderness and "viggora" in act_player.special_attributes:
			max_hit = max_hit * 3/2
		
		if "dharok" in act_player.special_attributes:
			max_hit = max_hit * ( 1 + (act_player.hp_lvl - act_player.current_hp)/100 * act_player.hp_lvl / 100 )
		if "verac" in act_player.special_attributes:
			crit_max_hit += 1
		
		if "colossal_blade" in act_player.special_attributes:
			var monsize : int = int( target_mon.size )
			max_hit = max_hit + ( 2 * int( min( monsize, 5 ) ) )
	
	stats.pre_roll_max = max_hit
	stats.pre_roll_crit = crit_max_hit
	
	stats.max_hit = max_hit * stats.post_roll_mult[0] / stats.post_roll_mult[1]
	stats.max_critical = crit_max_hit * stats.post_roll_mult[0] / stats.post_roll_mult[1]


func calc_monster_def_roll( )->int:
	var def_roll : int = 0
	var magic_attack : bool = act_player.attack_stance.is_magic()
	
	if magic_attack:
		def_roll = ( target_mon.magic_level + 9 ) * ( target_mon.style_def( "magic" ) + 64 )
	
	var monster_def_lvl : int = target_mon.defence_level
	if dwh_specs > 0:
			for _i in range(dwh_specs):
				monster_def_lvl = monster_def_lvl * 7 / 10
	
	if act_player.attack_stance.is_ranged():
		def_roll = ( monster_def_lvl + 9 ) * ( target_mon.style_def( "ranged" ) + 64 )
	else:
		
		def_roll = ( monster_def_lvl + 9 ) * ( target_mon.style_def( act_player.attack_stance.type2st() ) + 64 )

	return def_roll

func calc_hit_chance( atk_roll : int, def_roll : int, osmumten : bool )-> float:
	var p_hit_chance : float = 0
	if osmumten:
		# These are very ugly but seem to work.
		if atk_roll > def_roll:
			# p_hit_chance = 1 - 1/def_roll * ( 2 * def_roll^3 + 3 * def_roll^2 ) + def_roll ) / 6 / atk_roll^2
			p_hit_chance = 1 - 1.0/def_roll * ( 2*pow(def_roll,3) + 3*pow(def_roll, 2) + def_roll ) / 6.0 / pow(atk_roll, 2)
		elif atk_roll == def_roll:
			p_hit_chance = 2.0/3 - pow(def_roll,-2)/6 - pow(def_roll,-1)/2.0
		else:
			p_hit_chance = ( 4*pow(atk_roll, 2) + 3*atk_roll - 1 ) / ( 6.0 * atk_roll * def_roll ) - 1.0 / def_roll
	else:
		if atk_roll > def_roll:
			p_hit_chance = 1 - 0.5 * ( def_roll + 2.0 ) / ( atk_roll + 1.0 )
		else:
			p_hit_chance = 0.5 * atk_roll / ( def_roll + 1.0 )
	
	return p_hit_chance

func calc_player_atk_roll()->int:
	
	# Math mostly based on wiki
	# I do not trust this math at all
	
	var atk_roll : int
	
	if act_player.attack_stance.is_magic():
		var eff_atk : int = act_player.magic
		# Weird handling for different prayer bonuses. Npt sure about these. But
		eff_atk = int( eff_atk * act_player.prayer_magic )
		eff_atk = int( eff_atk * act_player.prayer_magic_atk )
		
		if "void_magic" in act_player.special_attributes:
			eff_atk = int( eff_atk * 1.45 )
		
		eff_atk += act_player.style_mag_bonus + 8
		atk_roll = eff_atk * ( act_player.magic_bonus + 64 )
		
		if "salve_ei" in act_player.special_attributes and "undead" in target_mon.attributes:
			atk_roll = int( atk_roll * 1.2 )
		elif "salve_i" in act_player.special_attributes and "undead" in target_mon.attributes:
			atk_roll = int( atk_roll * 7.0/6 ) # *1.16
		elif slayer_task and "black_mask_i" in act_player.special_attributes:
			atk_roll = int( atk_roll * 1.15 )
		
		if "tome_of_water" in act_player.special_attributes && "water" in act_player.spell.special_effects:
			atk_roll = atk_roll * 6/5
		if "somke_bass" in act_player.special_attributes:
			atk_roll = atk_roll * 11/10
		if wilderness and "thammaron" in act_player.special_attributes:
			atk_roll = atk_roll * 2
		
		if act_player.spell and "demonbane" in act_player.spell.special_effects and "demon" in target_mon.attributes:
			if mark_of_darkness: 
				atk_roll = atk_roll * 7/5
			else:
				atk_roll = atk_roll * 6/5
		
		if "tumekens_shadow" in act_player.special_attributes:
			atk_roll *= 3
		
	elif act_player.attack_stance.is_ranged():
		var eff_atk : int = int( act_player.ranged * act_player.prayer_rng * act_player.prayer_rng_atk ) + act_player.style_rng_bonus + 8
		
		if "void_ranged" in act_player.special_attributes:
			eff_atk = eff_atk * 11/10
		
		atk_roll = eff_atk * ( act_player.rng_bonus + 64 )
		
		if "salve_ei" in act_player.special_attributes and "undead" in target_mon.attributes:
			atk_roll = atk_roll * 6/5
		elif "salve_i" in act_player.special_attributes and "undead" in target_mon.attributes:
			atk_roll = atk_roll * 7/6
		elif slayer_task and "black_mask_i" in act_player.special_attributes:
			atk_roll = int( atk_roll * 1.15 )
		
		if "dragonhunter_crossbow" in act_player.special_attributes and "dragon" in target_mon.attributes:
			atk_roll = int( atk_roll * 1.3 )
		if wilderness and "craw" in act_player.special_attributes:
			atk_roll = atk_roll * 3/2
		
		if "twisted" in act_player.special_attributes:
			var mag : int = int( max( target_mon.magic_level, target_mon.attack_magic ) )
			var mult_1 : int = ( 10*3*mag / 10 - 10 ) / 100
			var mult_2 : int = ( 3*mag/10 - 100 )*( 3*mag/10 - 100 )/100
			var percent : int = int( clamp( 140 + mult_1 - mult_2, 0, 140 ) )
			atk_roll = atk_roll * percent / 100
		
		if "crystal_bow" in act_player.special_attributes:
			var acc_mult : float = 1
			if "carystal_body" in act_player.special_attributes:
				acc_mult += 0.15
			if "crystal_legs" in act_player.special_attributes:
				acc_mult += 0.10
			if "crystal_helm" in act_player.special_attributes:
				acc_mult += 0.05
			atk_roll = int( atk_roll * acc_mult)
	
	else:
		# Melee
		var eff_atk : int = int( act_player.attack * act_player.prayer_atk ) + act_player.style_atk_bonus + 8
		
		# These should probably be in same order as in max hit
		if "void_melee" in act_player.special_attributes:
			eff_atk = eff_atk * 11/10
		
		atk_roll = eff_atk * ( act_player.atk_bonus + 64 )
		
		if "obsidian_armor" in act_player.special_attributes:
			atk_roll = atk_roll * 11/10
		
		if "salve_e" in act_player.special_attributes and "undead" in target_mon.attributes:
			atk_roll = atk_roll * 6/5
		elif slayer_task and "black_mask" in act_player.special_attributes:
			atk_roll = atk_roll * 7/6
		elif "salve" in act_player.special_attributes and "undead" in target_mon.attributes:
			atk_roll = atk_roll * 7/6
		
		if "vampyre" in target_mon.attributes:
			if "blisterwood_flail" in act_player.special_attributes:
				atk_roll = atk_roll * 21/20
			elif "blisterwood_sickle" in act_player.special_attributes:
				atk_roll = atk_roll * 21/20
		if wilderness and "viggora" in act_player.special_attributes:
			atk_roll = atk_roll * 3/2
		if "arclight" in act_player.special_attributes && "demon" in target_mon.attributes:
			atk_roll = atk_roll * 17/10
		if act_player.attack_stance.is_crush():
			if "inquisitor_1" in act_player.special_attributes:
				atk_roll = int( atk_roll * 1.005 )
			elif "inquisitor_2" in act_player.special_attributes:
				atk_roll = int( atk_roll * 1.01 )
			elif "inquisitor_3" in act_player.special_attributes:
				atk_roll = int( atk_roll * 1.025 )
		if "dragonhunter_lance" in act_player.special_attributes && "dragon" in target_mon.attributes:
			atk_roll = atk_roll * 6/5
		if "leaf_baxe" in act_player.special_attributes && "leafy" in target_mon.attributes:
			atk_roll = int( atk_roll * 47/40 )
		if "keris_breaching" in act_player.special_attributes and ( "kalphite" in target_mon.attributes or "scabarite"  in target_mon.attributes ):
			atk_roll = atk_roll * 4 / 3
	
	return atk_roll


func calc_monster_atk_roll() -> int:
	
	if target_mon.attack_type.size() == 0:
		# Incomplete attack info
		return 0
	
	var atk_roll : int
	
	if target_mon.attack_type[0] == "magic":
		var eff_atk : int = target_mon.magic_level + 9
		atk_roll = eff_atk * ( target_mon.attack_magic  + 64 )
	elif target_mon.attack_type[0] == "ranged":
		var eff_atk : int = target_mon.ranged_level + 8
		atk_roll = eff_atk * ( target_mon.attack_ranged  + 64 )
	else:
		# Melee
		var eff_atk : int = target_mon.attack_level + 8
		atk_roll = eff_atk * ( target_mon.attack_bonus  + 64 )
	
	atk_roll = int( atk_roll * toa_multiplier )
	
	return atk_roll

func calc_player_def_roll()->int:
	
	if target_mon.attack_type.size() == 0:
		# Incomplete attack info
		return 0
	
	if target_mon.attack_type[0] == "magic":
		# This may be wrong but nobody knows better
		# 30% magic lvl, 70%  def lvl
		var eff_def : int = ( int( act_player.defence * act_player.prayer_def ) + act_player.style_def_bonus ) * 3 / 10
		eff_def += int( act_player.magic * act_player.prayer_magic ) * 7 / 10 + 8
		# Uhh... maybe
		eff_def = int( eff_def * act_player.prayer_magic_def )
		
		return eff_def * ( act_player.style_def( "magic" ) + 64 )
	elif target_mon.attack_type[0] == "ranged":
		var eff_def : int = int( act_player.defence * act_player.prayer_def ) + act_player.style_def_bonus + 8
		return eff_def * ( act_player.style_def( "ranged" ) + 64 )
	else:
		#melee
		var eff_def : int = int( act_player.defence * act_player.prayer_def ) + act_player.style_def_bonus + 8
		return eff_def * ( act_player.style_def( target_mon.attack_type[0] ) + 64 )


func simulate_combat( stats : dps_stats ) -> void:
	
	# Full tick accurate combat simulation
	
	var state : combat_state = preload("res://resources/combat_state.gd").new()
	state.initialize( act_player, target_mon, stats )
	state.toa = toa
	
	state.armour = HardcodedData.monster_armour( target_mon )
	
	var hit_func : Callable = Callable(self, "hit_normal")
	
	if "keris" in act_player.special_attributes:
		state.crit_chance = 1.0/51
		hit_func = Callable(self, "hit_critical")
	elif "keris_sun" in act_player.special_attributes:
		state.crit_chance = 1.0/51
		hit_func = Callable(self, "hit_keris_sun")
	elif "osmumtem" in act_player.special_attributes:
		hit_func = Callable(self, "hit_osmumten")
	elif "macuahuitl" in act_player.special_attributes:
		hit_func = Callable(self, "hit_macuahuitl")
	elif "gaddehammer" in act_player.special_attributes:
		state.crit_chance = 0.05
		hit_func = Callable(self, "hit_critical")
	elif "damned_ahrim" in act_player.special_attributes:
		hit_func = Callable(self, "hit_ahrim_damned")
	elif "damned_karil" in act_player.special_attributes:
		hit_func = Callable(self, "hit_karil_damned")
	elif "verac" in act_player.special_attributes:
		hit_func = Callable(self, "hit_verac")
	elif "onyx_bolt_e" in act_player.special_attributes and not ("undead" in target_mon.attributes):
			hit_func = Callable(self, "hit_onyx")
	elif "dragonstone_bolt_e" in act_player.special_attributes and not ("dragon" in target_mon.attributes):
			hit_func = Callable(self, "hit_dragonstone")
	elif "diamond_bolt_e" in act_player.special_attributes:
			hit_func = Callable(self, "hit_diamond")
	elif "ruby_bolt_e" in act_player.special_attributes:
			hit_func = Callable(self, "hit_ruby")
	elif "pearl_bolt_e" in act_player.special_attributes:
			hit_func = Callable(self, "hit_pearl")
	elif "opal_bolt_e" in act_player.special_attributes:
			hit_func = Callable(self, "opal")
	
	if kandarin_diary:
		state.kandarin = 1.1
	
	var bloodrager : bool = "bloodrager" in act_player.special_attributes
	var eclipse : bool = "eclipse" in act_player.special_attributes
	
	var magic_attack : bool = act_player.attack_stance.is_magic()
	state.zaryte = "zaryte_xbow" in act_player.special_attributes
	state.brimstone = magic_attack and "brimstone_ring" in act_player.special_attributes
	
	var simulated_kills : int = 10000
	var max_kill_duration : int = 2000 # Limit to prevent freezing
	
	var attacks : int = 0
	var hits : int = 0
	var kill_duration : int = 0
	var burn_last_applied : int = 0 # Tick on which burn was applied
	for _kills in range(1, simulated_kills):
		
		state.target_hp = state.target_max_hp
		kill_duration = 0
		while !state.is_dead():
			var damage : int = hit_func.call( state )
			assert( damage >= 0 ) # Must never be negative (would heal)
			state.target_hp -= damage
			attacks += 1
			hits += int( damage != 0 )
			
			if bloodrager and damage > 0 and state.chance( 1.0/3 ):
				state.duration -= 1
				kill_duration -= 1
			state.duration += state.attack_speed
			kill_duration += state.attack_speed
			
			if state.burn_stack > 0:
				var dur = state.duration - burn_last_applied
				var burn_dmg = min( dur / 4, state.burn_stack )
				if burn_dmg > 0:
					burn_last_applied = state.duration
					state.burn_stack -= burn_dmg
					state.target_hp -= burn_dmg
			
			if eclipse and damage > 0 and state.chance( 0.2 ):
				# I assume this can apply only when you actually hit
				state.burn_stack += 10
			
			if kill_duration >= max_kill_duration:
				print( "Too slow kills to simulate" )
				return
	
	stats.hit_chance_simulated = float(hits) / attacks
	stats.dps_simulated = ( simulated_kills * target_mon.hitpoints ) / ( state.duration * 0.6 )
	stats.ttk =  ( state.duration * 0.6 ) / simulated_kills

func attack_hits( state : combat_state ) -> bool:
	var def_roll : int = state.rng_roll( state.monster_def_roll)
	var atk_roll : int = state.rng_roll( state.player_atk_roll)
	if state.brimstone and state.chance( 0.25 ):
		def_roll = def_roll * 9 / 10
	if def_roll < atk_roll:
		return true
	return false

func base_damage( state : combat_state ) -> int:
	return state.rng_roll( state.pre_roll_max) * state.post_roll_mult[0] / state.post_roll_mult[1]

func hit_base( state : combat_state ) -> int:
	if attack_hits( state ):
		return base_damage( state )
	return 0

func apply_armour( damage : int, state : combat_state ) -> int:
	if state.armour == 0 or damage == 0:
		return damage
	if state.armour > 0:
		return max( damage - state.armour, 0 )
	return damage - state.armour

func hit_normal( state : combat_state ) -> int:
	var damage : int = hit_base( state )
	damage = apply_armour( damage, state )
	return damage

func hit_karil_damned( state : combat_state ) -> int:
	# 25% chance to do second hit for 1/2 of first hit
	if state.chance( 0.75 ):
		return hit_normal( state )
	var damage_1 : int = hit_base( state )
	var damage_2 : int = damage_1 / 2
	var damage : int = apply_armour( damage_1, state ) + apply_armour( damage_2, state )
	return damage

func hit_ahrim_damned( state : combat_state ) -> int:
	# 25% chance to do extra 30% damage
	if state.chance( 0.75 ):
		return hit_normal( state )
	var damage : int = hit_base( state )
	damage += damage * 1 / 3
	return apply_armour( damage, state )

func hit_verac( state : combat_state ) -> int:
	# 25% chance to quaranteed hit with +1 damage
	if state.chance( 0.25 ):
		return apply_armour( state.rng_roll( state.pre_roll_max) + 1, state )
	return hit_normal( state )

func hit_osmumten( state : combat_state ) -> int:
	var damage : int = 0
	if state.toa:
		# Roll for hit, then roll both again if first misses
		if attack_hits( state ):
			damage = state.rng.randi_range( state.pre_roll_max * 3/20, state.pre_roll_max * 17/20)
		elif attack_hits( state ):
			damage = state.rng.randi_range( state.pre_roll_max * 3/20, state.pre_roll_max * 17/20)
	# Attack is rolled again on miss (defence is kept same), effectively same as roling attack twice and taking max
	elif state.rng_roll( state.monster_def_roll) < max( state.rng_roll( state.player_atk_roll), state.rng_roll( state.player_atk_roll) ):
		damage = state.rng.randi_range( state.pre_roll_max * 3/20, state.pre_roll_max * 17/20)
	return apply_armour( damage, state )

func hit_vitur( state : combat_state ) -> int:
	# 3 separate hits
	# Full damage, 1/2 damage, 1/4 damage
	var damage : int = apply_armour( hit_base( state ), state )
	damage += apply_armour( hit_base( state ) / 2, state )
	damage += apply_armour( hit_base( state ) / 4, state )
	return damage

func hit_keris_sun( state : combat_state ) -> int:
	var hit_roll : int
	if state.toa and state.target_hp * 4 < state.target_max_hp:
		# 25% extra accuracy against target with 25% or less health
		hit_roll = state.rng_roll( state.player_atk_roll * 5/4)
	else:
		hit_roll = state.rng_roll( state.player_atk_roll)
	
	if state.rng_roll( state.monster_def_roll) >= hit_roll:
		return 0
	
	if state.chance( state.crit_chance ):
		return apply_armour( state.rng_roll( state.p_crit_max_hit), state )
	return apply_armour( state.rng_roll( state.pre_roll_max), state )

func hit_macuahuitl( state : combat_state ) -> int:
	# Two hits for half damage
	# If first hit misses second hit also misses
	# Second hit has its own accuracy check
	# If max hit is odd the second hit gets +1 damage
	var damage : int = 0
	if attack_hits( state ):
		damage += state.rng_roll( state.pre_roll_max) / 2 - state.armour
		if attack_hits( state ):
			damage += state.rng_roll( state.pre_roll_max) / 2 - state.armour
			damage += state.pre_roll_max % 2
	return damage

func hit_dual( state : combat_state ) -> int:
	# Two independent hits for half damage
	# Per-hit modifiers apply separately to both attacks
	# If max hit is odd +1 to second hit
	# Not too sure about this
	var max_hit : int = state.pre_roll_max * state.post_roll_mult[0] / state.post_roll_mult[1]
	var damage : int = 0
	if attack_hits( state ):
		damage += apply_armour( hit_base( state ) / 2, state )
	if attack_hits( state ):
		damage += apply_armour( hit_base( state ) / 2 + max_hit % 2, state )
	return damage

func hit_critical( state : combat_state ) -> int:
	# Weapon with critical chance (keris/gadderhammer)
	var def_roll : int = state.rng_roll( state.monster_def_roll)
	if state.brimstone and state.chance( 0.25 ):
		def_roll = def_roll * 9 / 10
	if def_roll >= state.rng_roll( state.player_atk_roll):
		return 0
	if state.chance( state.crit_chance ):
		return apply_armour( state.rng_roll( state.p_crit_max_hit) * state.post_roll_mult[0] / state.post_roll_mult[1], state )
	return base_damage( state )

func hit_onyx( state : combat_state ) -> int:
	# 11% chance to proc in pve
	# Hits for +20% damage (+30% with zaryte)
	# Leech life (not implemented)
	#TODO find if proc is checked before hit calc
	if state.chance( 0.11 * state.kandarin ):
		if state.zaryte:
			return apply_armour( state.rng_roll( state.pre_roll_max * 13/10), state )
		else:
			return apply_armour( state.rng_roll( state.pre_roll_max * 12/10), state )
	return hit_normal( state )

func hit_diamond( state : combat_state ) -> int:
	# Quaranteed hit for +15% damage (+25% with zaryte)
	if state.chance( 0.1 * state.kandarin ):
		if state.zaryte:
			return apply_armour( state.rng_roll( state.pre_roll_max * 5/4), state )
		else:
			return apply_armour( state.rng_roll( state.pre_roll_max * 23/20), state )
	return hit_normal( state )

func hit_ruby( state : combat_state ) -> int:
	# Deal 20% of target's remaining HP (max 100) (22% max 110 with zaryte)
	#TODO find if proc is checked before hit calc
	if state.chance( 0.06 * state.kandarin ):
		if state.zaryte:
			return apply_armour( int( min( 110, state.target_hp * 11/50 ) ), state )
		else:
			return apply_armour( int( min( 100, state.target_hp / 5 ) ), state )
	return hit_normal( state )

func hit_dragonstone( state : combat_state ) -> int:
	# +20% of rng lvl added to damage (+22% with szaryte)
	#TODO find if proc is checked before hit calc
	if state.chance( 0.06 * state.kandarin ):
		if state.zaryte:
			return apply_armour( state.rng_roll( state.pre_roll_max + state.p_ranged * 11 / 50 ) - state.armour, state )
		else:
			return apply_armour( state.rng_roll( state.pre_roll_max + state.p_ranged / 5 ) - state.armour, state )
	return hit_normal( state )

func hit_opal( state : combat_state ) -> int:
	# +1/10 of rng lvl added to damage
	#TODO find if proc is checked before hit calc
	if state.chance( 0.05 * state.kandarin ):
		if state.zaryte:
			return apply_armour( state.rng_roll( state.pre_roll_max + state.p_ranged / 9 ), state )
		else:
			return apply_armour( state.rng_roll( state.pre_roll_max + state.p_ranged / 10 ), state )
	return hit_normal( state )

func hit_pearl( state : combat_state ) -> int:
	# adds 1/15 of the player's rng lvl to fiery units damage, and 1/20 against other targets
	# Wiki doesn't list zaryte xbow effect on this. Numbers are guessed
	#TODO find if proc is checked before hit calc
	#TODO find zaryte effect
	if state.chance( 0.06 * state.kandarin ):
		if state.zaryte:
			if state.fiery:
				return apply_armour( state.rng_roll( state.pre_roll_max + state.p_ranged * 11 / 150 ), state )
			else:
				return apply_armour( state.rng_roll( state.pre_roll_max + state.p_ranged * 11 / 200 ), state )
		else:
			if state.fiery:
				return apply_armour( state.rng_roll( state.pre_roll_max + state.p_ranged / 15 ), state )
			else:
				return apply_armour( state.rng_roll( state.pre_roll_max + state.p_ranged / 20 ), state )
	return hit_normal( state )





