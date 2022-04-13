extends HBoxContainer



func _ready():
	var _err = $combat_sim.connect("simulation_done", $results, "refresh_results")


func player_equip( item : equipment):
	$player_data.equip( item )
	
	if item.equipment_slot == "weapon" or item.equipment_slot == "2h":
		$player_container/player/attack_style.set_slection( item )

func refresh_results():
	print("REFRES")
	$combat_sim.do_fast_simulations( $player_data, $monster.current_monster )
	$results.print_specials()
	$player_container/player.refresh_eq_stats()

func _on_player_data_gear_change(slot : String, new_gear : equipment):
	# Sets the gear visible on the buttons
	# Happens as a result of the actual player gear change
	get_node("player_container/player/" + slot ).add_gear( new_gear)

func set_monster( monster_node : monster ):
	$monster.set_monster( monster_node )
	refresh_results()


func _on_Button_pressed():
	$combat_sim.do_simulations( $player_data, $monster.current_monster )

func prayer_add( prayer_id : String ):
	if $player_data.prayer_add( prayer_id ):
		var prayer_button_scene := preload( "res://interface/pray_button.tscn")
		var button := prayer_button_scene.instance()
		button.pray_id = prayer_id
		var _err1 = button.connect( "button_down", $player_data, "prayer_remove", [prayer_id] )
		var _err2 = button.connect( "button_down", button, "remove_button" )
		$player_container/player/prayers.add_child( button )


func _on_name_text_changed(new_text):
	if new_text != "":
		name = new_text
		$player_data.setup_name = new_text

func save_data() -> String:
	return $player_data.save_string()

func load_data( new_data : String ):
	$player_data.load_string( new_data )
	$player_container/player/attack.value = $player_data.attack
	$player_container/player/strength.value = $player_data.strength
	$player_container/player/defence.value = $player_data.defence
	$player_container/player/magic.value = $player_data.magic
	$player_container/player/ranged.value = $player_data.ranged
	$player_container/player/hp_lvl.value = $player_data.hp_lvl
	$player_container/player/hp.value = $player_data.current_hp
	#$player/prayer.value = $player_data.prayer
	if $player_data.weapon:
		$player_container/player/attack_style.set_slection( $player_data.weapon )
