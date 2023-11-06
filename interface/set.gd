extends ScrollContainer



func _ready():
	set_monster( Database.get_monsters()[0] )
	$combat_sim.act_player = $player_data


func player_equip( item : equipment):
	$player_data.equip( item )
	
	if item.equipment_slot == "weapon" or item.equipment_slot == "2h":
		%player_panel/attack_style.set_slection( item )

func refresh_results():
	print("REFRES")
	$combat_sim.do_fast_simulations()
	%result_panel.print_specials()
	%player_panel.refresh_eq_stats()

func _on_player_data_gear_change(slot : String, new_gear : equipment):
	# Sets the gear visible on the buttons
	# Happens as a result of the actual player gear change
	get_node("%player_panel/" + slot ).add_gear( new_gear)

func _on_player_data_changed():
	refresh_results()

func set_monster( monster_node : monster ):
	%monster_panel.set_monster( monster_node )
	refresh_results()


func _on_Button_pressed():
	$combat_sim.target_mon = %monster_panel.current_monster
	$combat_sim.do_simulations( true )

func prayer_add( prayer_id : String ):
	$player_data.prayer_add( prayer_id )


func _on_name_text_changed(new_text):
	if new_text != "":
		name = new_text
		$player_data.setup_name = new_text

func save_data() -> String:
	return $player_data.save_string()

func load_data( new_data : String ):
	$player_data.load_string( new_data )
	get_node("%player_panel/attack").value = $player_data.attack
	get_node("%player_panel/strength").value = $player_data.strength
	get_node("%player_panel/defence").value = $player_data.defence
	get_node("%player_panel/magic").value = $player_data.magic
	get_node("%player_panel/ranged").value = $player_data.ranged
	get_node("%player_panel/hp_lvl").value = $player_data.hp_lvl
	get_node("%player_panel/hp").value = $player_data.current_hp
	#$player/prayer.value = $player_data.prayer
	if $player_data.weapon:
		get_node("%player_panel/attack_style").set_slection( $player_data.weapon )


