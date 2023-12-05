extends Node

var combat_sim = preload( "res://combat_sim.gd" ).new()

func _ready():
	print( "START: MAX HIT TEST" )
	simple_melee_test()
	print( "COMPLETED: MAX HIT TEST" )

func simple_melee_test():
	var attacker : player = preload( "res://data/player.gd" ).new()
	var defender : monster = Database.get_monster( 2098 ) # hill giant 2098
	
	combat_sim.act_player = attacker
	combat_sim.target_mon = defender
	
	attacker.equip( Database.get_item( 4587 ) ) # dragon scim 4587
	attacker.attack_stance = "aggressive"
	
	var max_hit : int
	
	attacker.strength = 20
	max_hit = combat_sim.do_simulations( false ).max_hit
	assert( max_hit == 6 )
	
	attacker.strength = 99
	max_hit = combat_sim.do_simulations( false ).max_hit
	assert( max_hit == 22 )

func simple_ranged_test():
	var attacker : player = preload( "res://data/player.gd" ).new()
	var defender : monster = Database.get_monster( 2098 ) # hill giant 2098
	
	combat_sim.act_player = attacker
	combat_sim.target_mon = defender
	
	attacker.equip( Database.get_item( 21902 ) ) # dragon crossbow 21902
	attacker.equip( Database.get_item( 21905 ) ) # dragon bolt 21905
	attacker.attack_stance = "rapid"
	
	var max_hit : int
	
	attacker.ranged = 20
	max_hit = combat_sim.do_simulations( false ).max_hit
	assert( max_hit == 8 )
	
	attacker.ranged = 99
	max_hit = combat_sim.do_simulations( false ).max_hit
	assert( max_hit == 31 )

func simple_magic_test():
	var attacker : player = preload( "res://data/player.gd" ).new()
	var defender : monster = Database.get_monster( 2098 ) # hill giant 2098
	
	combat_sim.act_player = attacker
	combat_sim.target_mon = defender
	
	
	attacker.equip( Database.get_item( 1389 ) ) # magic staff 1389
	attacker.equip( Database.get_item( -26 ) ) # fire surge -26
	
	attacker.attack_stance = "spellcasting"
	attacker.attack_style = "magic"
	
	var max_hit : int
	
	max_hit = combat_sim.do_simulations( false ).max_hit
	assert( max_hit == 24 )
