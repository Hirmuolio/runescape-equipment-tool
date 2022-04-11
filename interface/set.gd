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
	$player.refresh_eq_stats()

func _on_player_data_gear_change(slot : String, new_gear : equipment):
	# Sets the gear visible on the buttons
	# Happens as a result of the actual player gear change
	get_node("player/" + slot ).add_gear( new_gear)

func set_monster( monster_node : monster ):
	$monster.set_monster( monster_node )


func _on_Button_pressed():
	$combat_sim.do_simulations( $player_data, $monster.current_monster )

func prayer_add( prayer_id : String ):
	if $player_data.prayer_add( prayer_id ):
		var prayer_button_scene := preload( "res://interface/pray_button.tscn")
		var button := prayer_button_scene.instance()
		button.pray_id = prayer_id
		button.connect( "button_down", $player_data, "prayer_remove", [prayer_id] )
		button.connect( "button_down", button, "remove_button" )
		$player/prayers.add_child( button )

