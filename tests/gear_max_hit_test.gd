extends Node

var combat_sim = preload( "res://combat_sim.gd" ).new()

func _ready():
	print( "START: GEAR MAX HIT TEST" )
	undead_slayer()
	print( "COMPLETED: GEAR MAX HIT TEST" )

func undead_slayer():
	var attacker : player = preload( "res://data/player.gd" ).new()
	var defender : monster = Database.get_monster( 2992 ) # undead cow 2992
	
	combat_sim.act_player = attacker
	combat_sim.target_mon = defender
	
	attacker.equip( Database.get_item( -26 ) ) # fire surge -26
	attacker.equip( Database.get_item( 11865 ) ) # slayer helm 11865
	attacker.equip( Database.get_item( 11998 ) ) # smokoe battlestaff 11998
	attacker.equip( Database.get_item( 20714 ) ) # tome of fire 20714
	
	attacker.attack_stance = "spellcasting"
	
	var max_hit : int
	
	# Slayer helm, smoke battlestaff, tome of fire
	max_hit = combat_sim.do_simulations( false ).max_hit
	assert( max_hit == 43 )
	
	# Slayer helm, smoke battlestaff, tome of fire, salve (i)
	attacker.equip( Database.get_item( 12017 ) ) # salve (i) 12017
	max_hit = combat_sim.do_simulations( false ).max_hit
	assert( max_hit == 45 )
	
	# Slayer helm, smoke battlestaff, tome of fire, salve (ei)
	attacker.equip( Database.get_item( 12018 ) ) # salve (ei) 12018
	max_hit = combat_sim.do_simulations( false ).max_hit
	assert( max_hit == 46 )
	
	# smoke battlestaff, tome of fire, salve (ei)
	attacker.equip( Database.get_item( 1147 ) ) # rune med 1147 (take off slayer helm)
	max_hit = combat_sim.do_simulations( false ).max_hit
	assert( max_hit == 46 )
	
	# smoke battlestaff, tome of fire, salve (i)
	attacker.equip( Database.get_item( 12017 ) ) # salve (i) 12017
	max_hit = combat_sim.do_simulations( false ).max_hit
	assert( max_hit == 45 )
