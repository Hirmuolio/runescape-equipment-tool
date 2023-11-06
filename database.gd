extends Node

var items_path : String = "user://items/"
var monsters_path : String = "user://monsters/"

func _ready():
	#load_items_json()
	load_items_res()
	
	#load_monsters_json()
	load_monsters_res()
	
	HardcodedData.load_spells()

func get_items():
	return $items.get_children()

func  get_item( item_id : int ) -> Node:
	return $items.get_node( str(item_id) )

func get_monsters():
	return $monsters.get_children()

func get_monster( monster_id : int ) -> monster:
	return $monsters.get_node( str(monster_id) )

func load_items_json():
	# Loads all the equipment from items-complete.json
	print( "LOADING EQUIPMENT")
	var path = "res://database/items-complete.json"
	
	var file = FileAccess.open( path, FileAccess.READ )
	var test_json_conv = JSON.new()
	test_json_conv.parse( file.get_as_text() )
	var data : Dictionary = test_json_conv.get_data()
	
	# Take in only useful equipment
	var class_item = load( "res://data/equipment.tscn" )
	
	for item in data.values():
		if( !item["equipable_by_player"]):
			continue
		
		if HardcodedData.item_is_blacklisted( item["name"] ):
			continue
		
		if item["duplicate"] && item["duplicate"] == true:
			continue
		
		var new_item : equipment = class_item.instantiate()
		$items.add_child( new_item )
		
		new_item.item_name = item["name"]
		if item["examine"]:
			# Some items don't have examine info
			new_item.examine = item["examine"]
		new_item.item_id = item["id"]
		new_item.set_name( str( new_item.item_id ) )
		
		new_item.attack_stab = item["equipment"]["attack_stab"]
		new_item.attack_slash = item["equipment"]["attack_slash"]
		new_item.attack_crush = item["equipment"]["attack_crush"]
		new_item.attack_magic = item["equipment"]["attack_magic"]
		new_item.attack_ranged = item["equipment"]["attack_ranged"]
		
		new_item.defence_stab = item["equipment"]["defence_stab"]
		new_item.defence_slash = item["equipment"]["defence_slash"]
		new_item.defence_crush = item["equipment"]["defence_crush"]
		new_item.defence_magic = item["equipment"]["defence_magic"]
		new_item.defence_ranged = item["equipment"]["defence_ranged"]
		
		new_item.melee_strength = item["equipment"]["melee_strength"]
		new_item.ranged_strength = item["equipment"]["ranged_strength"]
		new_item.magic_damage_bonus = item["equipment"]["magic_damage"]
		
		new_item.prayer = item["equipment"]["prayer"]
		
		new_item.equipment_slot = item["equipment"]["slot"]
		
		if new_item.equipment_slot == "weapon" or new_item.equipment_slot == "2h":
			new_item.attack_speed = item["weapon"]["attack_speed"]
			new_item.stances = item["weapon"]["stances"]
		
		#all_equipment.push_back ( new_item )
		print( "Loaded: " + new_item.item_name)
	
	# Filter out duplicates.
	# get_child( int idx ) 
	# var children : Array = get_children()
	var item_count : int = $items.get_child_count()
	var i : int = 0
	while i < item_count-1:
		var first : equipment = $items.get_child( i )
		var duplpicates : Array = []
		for i2 in range( i+1, item_count ):
			var second : equipment =  $items.get_child( i2 )
			if first.is_identical(second):
				duplpicates.push_back(second)
		
		for dupl in duplpicates:
			print( "Duplicate: " + dupl.item_name)
			dupl.free()
		item_count = $items.get_child_count()
			
		i += 1
	
	# Create loaded variants of blowpipe
	var base_blowpipe : equipment = get_node("items/12926")
	var gen_id : int = -100
	var darts : Array = [ ["mithril", 9],
						["adamant", 17],
						["rune", 26],
						["amethyst", 28],
						["dragon", 35]
						]
	for dart in darts:
		var loaded_pipe : equipment = class_item.instantiate()
		$items.add_child( loaded_pipe )
		loaded_pipe.copy_from( base_blowpipe )
		loaded_pipe.ranged_strength += dart[1]
		loaded_pipe.item_name += " (" + dart[0] + ")"
		loaded_pipe.item_id = gen_id
		loaded_pipe.set_name( str( loaded_pipe.item_id ) )
		gen_id -= 1
	base_blowpipe.free()
	
	
	
	print( "EQUIPMENT LOADED")
	save_items_user()
	return

func unsigned16_to_signed( unsigned : int ):
	const MAX_15B = 1 << 15
	const MAX_16B = 1 << 16
	return (unsigned + MAX_15B) % MAX_16B - MAX_15B

func save_items_user():
	# Saves the item data so they don't need to be processed again.
	
	var monster_path : String = "res://database/item_data"
	var file = FileAccess.open( monster_path, FileAccess.WRITE)
	
	for _item in $items.get_children():
		var item : equipment = _item # Hack to get typing
		
		file.store_pascal_string( item.item_name )
		file.store_pascal_string( item.equipment_slot )
		file.store_32( item.item_id )
		file.store_pascal_string( item.examine )
		
		file.store_16( item.attack_stab )
		file.store_16( item.attack_slash )
		file.store_16( item.attack_crush )
		file.store_16( item.attack_magic )
		file.store_16( item.attack_ranged )
		
		file.store_16( item.defence_stab )
		file.store_16( item.defence_slash )
		file.store_16( item.defence_crush )
		file.store_16( item.defence_magic )
		file.store_16( item.defence_ranged )
		
		file.store_16( item.melee_strength )
		file.store_16( item.ranged_strength )
		file.store_16( item.magic_damage_bonus )
		file.store_16( item.prayer )
		
		file.store_8( item.attack_speed )
		file.store_pascal_string( var_to_str(item.stances) )


func load_items_res():
	var class_item = load( "res://data/equipment.tscn" )
	var file_path = "res://database/item_data"
	
	var file = FileAccess.open( file_path, FileAccess.READ)
	
	while file.get_position() < file.get_length():
		var new_item : equipment = class_item.instantiate()
		$items.add_child( new_item )
		
		new_item.item_name = file.get_pascal_string()
		new_item.equipment_slot = file.get_pascal_string()
		new_item.item_id = file.get_32()
		new_item.examine = file.get_pascal_string()
		
		new_item.set_name( str( new_item.item_id ) )
		
		new_item.attack_stab = unsigned16_to_signed( file.get_16() )
		new_item.attack_slash = unsigned16_to_signed( file.get_16() )
		new_item.attack_crush = unsigned16_to_signed( file.get_16() )
		new_item.attack_magic = unsigned16_to_signed( file.get_16() )
		new_item.attack_ranged = unsigned16_to_signed( file.get_16() )
		
		new_item.defence_stab = unsigned16_to_signed( file.get_16() )
		new_item.defence_slash = unsigned16_to_signed( file.get_16() )
		new_item.defence_crush = unsigned16_to_signed( file.get_16() )
		new_item.defence_magic = unsigned16_to_signed( file.get_16() )
		new_item.defence_ranged = unsigned16_to_signed( file.get_16() )
		
		new_item.melee_strength = unsigned16_to_signed( file.get_16() )
		new_item.ranged_strength = unsigned16_to_signed( file.get_16() )
		new_item.magic_damage_bonus = unsigned16_to_signed( file.get_16() )
		new_item.prayer = unsigned16_to_signed( file.get_16() )
		
		new_item.attack_speed = file.get_8()
		new_item.stances = str_to_var( file.get_pascal_string() )


func load_monsters_json():
	# Loads all the monsters from monsters-complete.json
	print( "LOADING MONSTERS")
	var path = "res://database/monsters-complete.json"
	
	var file = FileAccess.open( path, FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text())
	var data : Dictionary = test_json_conv.get_data()
	
	# Take in only useful equipment
	var class_monster = load( "res://data/monster.tscn" )
	
	for monster in data.values():
		if !monster["hitpoints"] or !monster["attack_speed"] or !monster["max_hit"]:
			# Some invalid monster.
			continue
		
		var new_monster : monster = class_monster.instantiate()
		$monsters.add_child( new_monster )
		
		new_monster.monster_name = monster["name"]
		new_monster.monster_id = monster["id"]
		new_monster.examine = monster["examine"]
		
		new_monster.set_name( str( new_monster.monster_id ) )
		
		new_monster.hitpoints = monster["hitpoints"]
		new_monster.attack_level = monster["attack_level"]
		new_monster.strength_level = monster["strength_level"]
		new_monster.defence_level = monster["defence_level"]
		new_monster.magic_level = monster["magic_level"]
		new_monster.ranged_level = monster["ranged_level"]
		
		new_monster.combat_level = monster["combat_level"]
		
		new_monster.attack_bonus = monster["attack_bonus"]
		new_monster.strength_bonus = monster["strength_bonus"]
		new_monster.attack_magic = monster["attack_magic"]
		new_monster.str_magic = monster["magic_bonus"]
		new_monster.attack_ranged = monster["attack_ranged"]
		new_monster.str_ranged = monster["ranged_bonus"]
		
		new_monster.defence_stab = monster["defence_stab"]
		new_monster.defence_slash = monster["defence_slash"]
		new_monster.defence_crush = monster["defence_crush"]
		new_monster.defence_magic = monster["defence_magic"]
		new_monster.defence_ranged = monster["defence_ranged"]
		
		new_monster.attributes = monster["attributes"]
		# Workaround for the data
		if monster["category"] && monster["category"][0] == "scabarites":
			new_monster.attributes.append( "scabarite" )
		
		new_monster.attack_speed = monster["attack_speed"]
		new_monster.attack_type = monster["attack_type"]
		new_monster.max_hit = monster["max_hit"]
		new_monster.size = monster["size"]
	
	# Filter out duplicates.
	var monster_count : int = $monsters.get_child_count()
	var i : int = 0
	while i < monster_count-1:
		var first : monster = $monsters.get_child( i )
		var duplpicates : Array = []
		for i2 in range( i+1, monster_count ):
			var second : monster =  $monsters.get_child( i2 )
			if first.is_identical(second):
				duplpicates.push_back(second)
		
		for dupl in duplpicates:
			print( "Duplicate: " + dupl.monster_name)
			dupl.free()
		monster_count = $monsters.get_child_count()
			
		i += 1
	
	save_monsters()

func save_monsters():
	# Saves the monster data so they don't need to be processed again.
	
	var monster_path : String = "res://database/monster_data"
	var file = FileAccess.open( monster_path, FileAccess.WRITE)
	
	for _monster in $monsters.get_children():
		var monster : monster = _monster # Hack to get typing
		
		file.store_pascal_string( monster.monster_name )
		file.store_32( monster.monster_id )
		file.store_pascal_string( monster.examine )
		
		file.store_16( monster.attack_level )
		file.store_16( monster.strength_level )
		file.store_16( monster.magic_level )
		file.store_16( monster.ranged_level )
		file.store_16( monster.defence_level )
		file.store_16( monster.hitpoints )
		
		file.store_16( monster.combat_level )
		
		file.store_16( monster.attack_bonus )
		file.store_16( monster.strength_bonus )
		file.store_16( monster.attack_magic )
		file.store_16( monster.str_magic )
		file.store_16( monster.attack_ranged )
		file.store_16( monster.str_ranged )
		
		file.store_16( monster.max_hit )
		
		file.store_16( monster.defence_stab )
		file.store_16( monster.defence_slash )
		file.store_16( monster.defence_crush )
		file.store_16( monster.defence_magic )
		file.store_16( monster.defence_ranged )
		
		file.store_8( monster.attack_speed )
		file.store_8( monster.size )
		
		file.store_pascal_string( var_to_str(monster.attack_type) )
		file.store_pascal_string( var_to_str(monster.attributes) )


func load_monsters_res():
	var file_path = "res://database/monster_data"
	var class_monster = load( "res://data/monster.tscn" )
	
	var file = FileAccess.open( file_path, FileAccess.READ)
	
	while file.get_position() < file.get_length():
		var new_monster : monster = class_monster.instantiate()
		$monsters.add_child( new_monster )
		
		new_monster.monster_name = file.get_pascal_string()
		new_monster.monster_id = file.get_32()
		new_monster.examine = file.get_pascal_string()
		
		new_monster.set_name( str( new_monster.monster_id ) )
		
		new_monster.attack_level = unsigned16_to_signed( file.get_16() )
		new_monster.strength_level = unsigned16_to_signed( file.get_16() )
		new_monster.magic_level = unsigned16_to_signed( file.get_16() )
		new_monster.ranged_level = unsigned16_to_signed( file.get_16() )
		new_monster.defence_level = unsigned16_to_signed( file.get_16() )
		new_monster.hitpoints = unsigned16_to_signed( file.get_16() )
		
		new_monster.combat_level = unsigned16_to_signed( file.get_16() )
		
		new_monster.attack_bonus = unsigned16_to_signed( file.get_16() )
		new_monster.strength_bonus = unsigned16_to_signed( file.get_16() )
		new_monster.attack_magic = unsigned16_to_signed( file.get_16() )
		new_monster.str_magic = unsigned16_to_signed( file.get_16() )
		new_monster.attack_ranged = unsigned16_to_signed( file.get_16() )
		new_monster.str_ranged = unsigned16_to_signed( file.get_16() )
		
		new_monster.max_hit = unsigned16_to_signed( file.get_16() )
		
		new_monster.defence_stab = unsigned16_to_signed( file.get_16() )
		new_monster.defence_slash = unsigned16_to_signed( file.get_16() )
		new_monster.defence_crush = unsigned16_to_signed( file.get_16() )
		new_monster.defence_magic = unsigned16_to_signed( file.get_16() )
		new_monster.defence_ranged = unsigned16_to_signed( file.get_16() )
		
		new_monster.attack_speed = file.get_8()
		new_monster.size = file.get_8()
		
		new_monster.attack_type = str_to_var( file.get_pascal_string() )
		new_monster.attributes = str_to_var( file.get_pascal_string() )

