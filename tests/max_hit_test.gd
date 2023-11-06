extends Node

var combat_sim = preload( "res://combat_sim.gd" ).new()

func _ready():
	simple_melee_test()

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
