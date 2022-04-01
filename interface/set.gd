extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$combat_sim.connect("simulation_done", $results, "refresh_results")
	pass # Replace with function body.


func player_equip( item : equipment):
	$player_data.equip( item )
	
	if item.equipment_slot == "weapon" or item.equipment_slot == "2h":
		$player/attack_style.set_slection( item )

func refresh_results():
	print("REFRES")
	$combat_sim.do_fast_simulations( $player_data, $monster.current_monster )
	$results.print_specials( $player_data )

func _on_player_data_gear_change(slot : String, new_gear : equipment):
	# Sets the gear visible on the buttons
	get_node("player/" + slot ).add_gear( new_gear)

func set_monster( monster_node : monster ):
	$monster.set_monster( monster_node )
	pass


func _on_Button_pressed():
	$combat_sim.do_simulations( $player_data, $monster.current_monster )
	pass # Replace with function body.
