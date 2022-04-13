extends Node

var items_path : String = "user://items/"
var monsters_path : String = "user://monsters/"

func _ready():
	#load_items_json()
	load_items_res()
	
	#load_monsters_json()
	load_monsters_res()

func get_items():
	return $items.get_children()

func  get_item( item_id : int ) -> Node:
	return $items.get_node( str(item_id) )

func get_monsters():
	return $monsters.get_children()

func load_items_json():
	# Loads all the equipment from items-complete.json
	print( "LOADING EQUIPMENT")
	var path = "res://items-complete.json"
	
	var file = File.new()
	file.open(path, File.READ)
	var data : Dictionary = parse_json(file.get_as_text())
	
	# Take in only useful equipment
	var class_item = load( "res://data/equipment.tscn" )
	
	for item in data.values():
		if( !item["equipable_by_player"]):
			continue
		
		if HardcodedData.item_is_blacklisted( item["name"] ):
			continue
		
		var new_item : equipment = class_item.instance()
		$items.add_child( new_item )
		
		new_item.item_name = item["name"]
		if item["examine"]:
			# Some items don't have examine info
			new_item.examine = item["examine"]
		new_item.item_id = item["id"]
		new_item.set_name( String( new_item.item_id ) )
		
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
		new_item.magic_damage = item["equipment"]["magic_damage"]
		
		new_item.magic_damage = item["equipment"]["magic_damage"]
		
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
	
	print( "EQUIPMENT LOADED")
	save_items_user()
	return


func save_items_user():
	# Saves the item data so they don't need to be processed again.
	
	var dir = Directory.new()
	if !dir.dir_exists( "res://database/" ):
		push_error ( "res://database/ does not exist" )
	
	var monster_path : String = "res://database/item_data"
	var file = File.new()
	file.open(monster_path, File.WRITE)
	
	
	for _item in $items.get_children():
		var item : equipment = _item # Hack to get typing
		
		file.store_pascal_string( item.item_name )
		file.store_pascal_string( item.equipment_slot )
		file.store_32( item.item_id )
		file.store_pascal_string( item.examine )
		
		file.store_64( item.attack_stab )
		file.store_64( item.attack_slash )
		file.store_64( item.attack_crush )
		file.store_64( item.attack_magic )
		file.store_64( item.attack_ranged )
		
		file.store_64( item.defence_stab )
		file.store_64( item.defence_slash )
		file.store_64( item.defence_crush )
		file.store_64( item.defence_magic )
		file.store_64( item.defence_ranged )
		
		file.store_64( item.melee_strength )
		file.store_64( item.ranged_strength )
		file.store_64( item.magic_damage )
		file.store_64( item.prayer )
		
		file.store_64( item.attack_speed )
		file.store_pascal_string( var2str(item.stances) )


func load_items_res():
	var class_item = load( "res://data/equipment.tscn" )
	var file_path = "res://database/item_data"
	
	var file = File.new()
	file.open( file_path , File.READ )
	while file.get_position() < file.get_len():
		var new_item : equipment = class_item.instance()
		$items.add_child( new_item )
		
		new_item.item_name = file.get_pascal_string()
		new_item.equipment_slot = file.get_pascal_string()
		new_item.item_id = file.get_32()
		new_item.examine = file.get_pascal_string()
		
		new_item.set_name( String( new_item.item_id ) )
		
		new_item.attack_stab = file.get_64()
		new_item.attack_slash = file.get_64()
		new_item.attack_crush = file.get_64()
		new_item.attack_magic = file.get_64()
		new_item.attack_ranged = file.get_64()
		
		new_item.defence_stab = file.get_64()
		new_item.defence_slash = file.get_64()
		new_item.defence_crush = file.get_64()
		new_item.defence_magic = file.get_64()
		new_item.defence_ranged = file.get_64()
		
		new_item.melee_strength = file.get_64()
		new_item.ranged_strength = file.get_64()
		new_item.magic_damage = file.get_64()
		new_item.prayer = file.get_64()
		
		new_item.attack_speed = file.get_64()
		new_item.stances = str2var( file.get_pascal_string() )


func load_monsters_json():
	# Loads all the monsters from monsters-complete.json
	print( "LOADING MONSTERS")
	var path = "res://monsters-complete.json"
	
	var file = File.new()
	file.open(path, File.READ)
	var data : Dictionary = parse_json(file.get_as_text())
	
	# Take in only useful equipment
	var class_monster = load( "res://data/monster.tscn" )
	
	for monster in data.values():
		if !monster["hitpoints"] or !monster["attack_speed"] or !monster["max_hit"]:
			# Some invalid monster.
			continue
		
		var new_monster : monster = class_monster.instance()
		$monsters.add_child( new_monster )
		
		new_monster.monster_name = monster["name"]
		new_monster.monster_id = monster["id"]
		new_monster.examine = monster["examine"]
		
		new_monster.set_name( String( new_monster.monster_id ) )
		
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
	var dir = Directory.new()
	if !dir.dir_exists( "res://database/" ):
		push_error ( "res://database/ does not exist" )
	
	var monster_path : String = "res://database/monster_data"
	var file = File.new()
	file.open(monster_path, File.WRITE)
	
	for _monster in $monsters.get_children():
		var monster : monster = _monster # Hack to get typing
		
		file.store_pascal_string( monster.monster_name )
		file.store_32( monster.monster_id )
		file.store_pascal_string( monster.examine )
		
		file.store_64( monster.attack_level )
		file.store_64( monster.strength_level )
		file.store_64( monster.magic_level )
		file.store_64( monster.ranged_level )
		file.store_64( monster.defence_level )
		file.store_64( monster.hitpoints )
		
		file.store_64( monster.combat_level )
		
		file.store_64( monster.attack_bonus )
		file.store_64( monster.strength_bonus )
		file.store_64( monster.attack_magic )
		file.store_64( monster.str_magic )
		file.store_64( monster.attack_ranged )
		file.store_64( monster.str_ranged )
		
		file.store_64( monster.max_hit )
		
		file.store_64( monster.defence_stab )
		file.store_64( monster.defence_slash )
		file.store_64( monster.defence_crush )
		file.store_64( monster.defence_magic )
		file.store_64( monster.defence_ranged )
		
		file.store_64( monster.attack_speed )
		file.store_pascal_string( monster.size )
		
		file.store_pascal_string( var2str(monster.attack_type) )
		file.store_pascal_string( var2str(monster.attributes) )


func load_monsters_res():
	var file_path = "res://database/monster_data"
	var class_monster = load( "res://data/monster.tscn" )
	
	var file = File.new()
	file.open( file_path , File.READ )
	
	while file.get_position() < file.get_len():
		var new_monster : monster = class_monster.instance()
		$monsters.add_child( new_monster )
		
		new_monster.monster_name = file.get_pascal_string()
		new_monster.monster_id = file.get_32()
		new_monster.examine = file.get_pascal_string()
		
		new_monster.set_name( String( new_monster.monster_id ) )
		
		new_monster.attack_level = file.get_64()
		new_monster.strength_level = file.get_64()
		new_monster.magic_level = file.get_64()
		new_monster.ranged_level = file.get_64()
		new_monster.defence_level = file.get_64()
		new_monster.hitpoints = file.get_64()
		
		new_monster.combat_level = file.get_64()
		
		new_monster.attack_bonus = file.get_64()
		new_monster.strength_bonus = file.get_64()
		new_monster.attack_magic = file.get_64()
		new_monster.str_magic = file.get_64()
		new_monster.attack_ranged = file.get_64()
		new_monster.str_ranged = file.get_64()
		
		new_monster.max_hit = file.get_64()
		
		new_monster.defence_stab = file.get_64()
		new_monster.defence_slash = file.get_64()
		new_monster.defence_crush = file.get_64()
		new_monster.defence_magic = file.get_64()
		new_monster.defence_ranged = file.get_64()
		
		new_monster.attack_speed = file.get_64()
		new_monster.size = file.get_pascal_string()
		
		new_monster.attack_type = str2var( file.get_pascal_string() )
		new_monster.attributes = str2var( file.get_pascal_string() )
	
	file.close()

