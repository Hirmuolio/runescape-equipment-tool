extends Node

class_name player
#func get_class(): return "player"

signal gear_change( slot, new_gear )

var setup_name : String = "untitled"

# Levels
var attack : int = 1
var strength : int = 1
var magic : int = 1
var ranged : int = 1
var defence : int = 1
var prayer : int = 1
var hp_lvl : int = 1

var current_hp : int = 1

# Equipment
var weapon : equipment
var shield : equipment
var head : equipment
var body : equipment
var legs : equipment
var feet : equipment
var cape : equipment
var ammo : equipment
var ring : equipment
var neck : equipment
var hands : equipment
var spell : equipment


# slash, crush, stab, magic, ranged
var attack_style : String = "crush"

# aggressive, defensive, accurate, controlled
# rapid, long range, accurate
# spellcasting, defensive casting
var attack_stance : String


# Equipment stats:
var str_bonus : int : get = _get_str_bonus
var atk_bonus : int : get = _get_atk_bonus
var rng_str_bonus : int setget, _get_rng_str
var rng_bonus : int setget, _get_rng
var magic_bonus : int setget, _get_magic_bonus
var mag_dmg_bonus : int setget, _get_mag_dmg_bonus

# Modifiers from activ prayers
var prayer_str : float : get = _get_pray_str
var prayer_atk : float : get = _get_pray_atk
var prayer_def : float : get = _get_pray_def
var prayer_rng : float : get = _get_pray_rng
var prayer_rng_atk : float : get = _get_pray_rng_atk
var prayer_rng_str : float : get = _get_pray_rng_str
var prayer_magic : float : get = _get_pray_magic
var prayer_magic_atk : float : get = _get_pray_magic_atk
var prayer_magic_def : float : get = _get_pray_magic_def

# Modifiers from attack style
var style_str_bonus : int : get = _get_style_str
var style_atk_bonus : int : get = _get_style_atk
var style_def_bonus : int : get = _get_style_def
var style_rng_bonus : int : get = _get_style_rng
var style_mag_bonus : int : get = _getstyle_mag

var other_str_bonus : float = 1 #TODO
var other_atk_bonus : float = 1 #TODO
var other_def_bonus : float = 1 #TODO

var attack_speed : int : get = _get_attack_speed

var prayers : Array = []
var special_attributes : Array = []

# Signals for refreshing UI

signal prayers_changed()

func save_string() -> String:
	var ret = ""
	ret += setup_name + "\n"
	
	# attack, str, def, mage, range, hp, pray
	ret += str(attack) + "," + str(strength) + "," + str(defence) + "," + str(ranged) + "," + str(magic) + "," + str(hp_lvl) + "," + str( prayer ) + "\n"
	
	for item in all_equipped():
		if item:
			ret += str(item.item_id) + ","
		else:
			ret += "-1,"
	
	# Remove the unnecessary last ,
	ret.erase( ret.length()-1, 1 )
	
	return ret

func load_string( setup : String ):
	# Should probably add some validation here...
	var data : PackedStringArray = setup.split("\n")
	setup_name = data[0]
	data.remove_at(0)
	
	var levels : PackedStringArray = data[0].split( ",")
	attack = int(levels[0])
	strength = int(levels[1])
	defence = int(levels[2])
	ranged = int(levels[3])
	magic = int(levels[4])
	hp_lvl = int(levels[5])
	current_hp = hp_lvl
	prayer = int(levels[6])
	data.remove_at(0)
	
	var gear_ids : PackedStringArray = data[0].split( ",")
	for gid in gear_ids:
		if int(gid) == -1:
			continue
		equip( Database.get_item( int(gid) ) )
	recalculate_stats()

func set_specials():
	# Determines what special attributes the equipment has
	# Takes into account conflicts and set requirements
	
	special_attributes = []
	
	# All specials and number of occurences
	# { "special_id": 2 }
	var all_specials : Dictionary = {}
	
	for item in all_equipped():
		for special in HardcodedData.specials_of_item( item ):
			if special in all_specials:
				all_specials[special] = all_specials[special] + 1
			else:
				all_specials[special] = 1
	
	# Apply full armor sets
	for special in all_specials.keys():
		if "set" in HardcodedData.equipment_specials[special]:
			if all_specials[special] < HardcodedData.equipment_specials[special]["set"]:
				continue
		if !special_attributes.has( special ):
			special_attributes.append( special )
	
	# Filter out exclusive specials
	var to_remove : Array = []
	for special in special_attributes:
		if "removes" in HardcodedData.equipment_specials[special]:
			to_remove.append_array( HardcodedData.equipment_specials[special]["removes"] )
	for rem in to_remove:
		special_attributes.erase( rem )

func recalculate_stats():
	get_parent().refresh_results()
	pass

func all_equipped() -> Array:
	# returns list of requipment
	var ret = []
	if weapon:
		ret.append(weapon)
	if shield:
		ret.append(shield)
	if head:
		ret.append(head)
	if body:
		ret.append(body)
	if legs:
		ret.append(legs)
	if feet:
		ret.append(feet)
	if cape:
		ret.append(cape)
	if ammo:
		ret.append(ammo)
	if ring:
		ret.append(ring)
	if neck:
		ret.append(neck)
	if hands:
		ret.append(hands)
	
	return ret

func equip( new_item : equipment  ):
	if new_item.equipment_slot == "2h":
		weapon = new_item
		shield = null
		emit_signal("gear_change", "weapon", new_item)
		emit_signal("gear_change", "shield", null)
	else:
		set( new_item.equipment_slot, new_item)
		emit_signal("gear_change", new_item.equipment_slot, new_item)
	set_specials()
	recalculate_stats()

func prayer_add( prayer_id : String ):
	if prayer_id in prayers:
		return
	
	# Can't have multiple prayers of same "type"
	# Remove old conflicting prayers
	var to_remove : Array = []
	for mod in HardcodedData.prayers[prayer_id]["type"]:
		for pra in prayers:
			if mod in HardcodedData.prayers[pra]["type"]:
				to_remove.append( pra )
	for pra in to_remove:
		prayers.erase( pra )
	
	prayers.append( prayer_id )
	
	recalculate_stats()
	emit_signal("prayers_changed")

func prayer_remove( prayer_id : String ):
	prayers.erase( prayer_id )
	recalculate_stats()

func _on_remove_gear(slot : String):
	if slot == "2h":
		weapon = null
	else:
		set( slot, null)
	set_specials()
	recalculate_stats()
	


func _on_attack_value_changed( new_lvl ):
	attack = new_lvl
	recalculate_stats()


func _on_strength_value_changed( new_lvl ):
	strength = new_lvl
	recalculate_stats()


func _on_defence_value_changed( new_lvl ):
	defence =  new_lvl
	recalculate_stats()


func _on_magic_value_changed( new_lvl ):
	magic = new_lvl
	recalculate_stats()


func _on_ranged_value_changed( new_lvl ):
	ranged = new_lvl
	recalculate_stats()

func _on_hp_lvl_value_changed(new_lvl):
	hp_lvl = new_lvl
	recalculate_stats()


func _on_hp_value_changed(new_lvl):
	current_hp = new_lvl
	recalculate_stats()

func _on_attack_style_attack_style(new_stance):
	attack_stance = new_stance[0]
	attack_style = new_stance[1]
	recalculate_stats()

func _get_style_str() -> int:
	if attack_stance == "aggressive" or attack_stance == "scorch":
		return 3
	elif attack_stance == "controlled":
		return 1
	return 0

func _get_style_atk() -> int:
	if attack_stance == "accurate":
		return 3
	elif attack_stance == "controlled":
		return 1
	return 0

func _get_style_def() -> int:
	if attack_stance == "defensive":
		return 3
	elif attack_stance == "controlled":
		return 1
	return 0

func _get_style_rng() -> int:
	if attack_stance == "accurate" or attack_stance == "flare":
		return 3
	elif attack_stance == "longrange":
		return 1
	return 0

func _getstyle_mag() -> int:
	if attack_stance == "accurate" or attack_stance == "blaze":
		return 3
	return 0

func get_equipment_bonus( attribute : String ) -> int:
	var bonus : int = 0
	
	if weapon:
		bonus += weapon.get( attribute )
	if shield:
		bonus += shield.get( attribute )
	if head:
		bonus += head.get( attribute )
	if body:
		bonus += body.get( attribute )
	if legs:
		bonus += legs.get( attribute )
	if feet:
		bonus += feet.get( attribute )
	if cape:
		bonus += cape.get( attribute )
	if ammo:
		bonus += ammo.get( attribute )
	if ring:
		bonus += ring.get( attribute )
	if neck:
		bonus += neck.get( attribute )
	if hands:
		bonus += hands.get( attribute )
	
	return bonus

func _get_str_bonus() -> int:
	return get_equipment_bonus( "melee_strength" )

func _get_atk_bonus() -> int:
	if attack_style == "stab":
		return get_equipment_bonus( "attack_stab" )
	elif attack_style == "slash":
		return get_equipment_bonus( "attack_slash" )
	elif attack_style == "crush":
		return get_equipment_bonus( "attack_crush" )
	
	#push_warning ( "Invalid weapon melee attack style " + '"' + attack_style + '"' )
	return get_equipment_bonus( "attack_stab" )

func _get_rng_str() -> int:
	return get_equipment_bonus( "ranged_strength" )

func _get_rng() -> int:
	return get_equipment_bonus( "attack_ranged" )

func _get_magic_bonus() -> int:
	return get_equipment_bonus( "attack_magic" )

func _get_mag_dmg_bonus() -> int:
	return get_equipment_bonus( "magic_damage_bonus" )

func style_def( ag_attack_style : String ) -> int:
	
	if ag_attack_style == "stab":
		return get_equipment_bonus( "defence_stab" )
	elif ag_attack_style == "slash":
		return get_equipment_bonus( "defence_slash" )
	elif ag_attack_style == "crush":
		return get_equipment_bonus( "defence_crush" )
	elif ag_attack_style == "magic":
		return get_equipment_bonus( "defence_magic" )
	elif ag_attack_style == "ranged":
		return get_equipment_bonus( "defence_ranged" )
	
	elif ag_attack_style == "melee":
		print( "Unknown monster attack style: ", ag_attack_style )
		return get_equipment_bonus( "defence_slash" )
	push_warning ( "Invalid monster melee attack style " + '"' + ag_attack_style + '"' )
	return 0


func _get_attack_speed() -> int:
	# Ticks per attack
	if !weapon:
		return 5
	var spd : int = weapon.attack_speed
	if "powered_staff" in special_attributes:
		spd = 4
	if attack_stance == "magic":
		spd = 5
	elif attack_stance == "rapid":
		spd -= 1
	return spd
	

func _get_pray_str() -> float:
	for pray_id in prayers:
		if not "modifiers" in HardcodedData.prayers[pray_id]:
			continue
		if "strength" in HardcodedData.prayers[pray_id]["modifiers"]:
			return ( 100.0 + HardcodedData.prayers[pray_id]["modifiers"]["strength"] ) / 100
	return 1.0

func _get_pray_atk() -> float:
	
	for pray_id in prayers:
		if not "modifiers" in HardcodedData.prayers[pray_id]:
			continue
		if "attack" in HardcodedData.prayers[pray_id]["modifiers"]:
			return ( 100.0 + HardcodedData.prayers[pray_id]["modifiers"]["attack"] ) / 100
	return 1.0

func _get_pray_def() -> float:
	for pray_id in prayers:
		if not "modifiers" in HardcodedData.prayers[pray_id]:
			continue
		if "defence" in HardcodedData.prayers[pray_id]["modifiers"]:
			return ( 100.0 + HardcodedData.prayers[pray_id]["modifiers"]["defence"] ) / 100
	return 1.0

func _get_pray_magic() -> float:
	for pray_id in prayers:
		if not "modifiers" in HardcodedData.prayers[pray_id]:
			continue
		if "magic" in HardcodedData.prayers[pray_id]["modifiers"]:
			return ( 100.0 + HardcodedData.prayers[pray_id]["modifiers"]["magic"] ) / 100
	return 1.0

func _get_pray_magic_atk() -> float:
	for pray_id in prayers:
		if not "modifiers" in HardcodedData.prayers[pray_id]:
			continue
		if "magic" in HardcodedData.prayers[pray_id]["modifiers"]:
			return ( 100.0 + HardcodedData.prayers[pray_id]["modifiers"]["magic"] ) / 100
	return 1.0

func _get_pray_magic_def()-> float:
	for pray_id in prayers:
		if not "modifiers" in HardcodedData.prayers[pray_id]:
			continue
		if "magic_attack" in HardcodedData.prayers[pray_id]["modifiers"]:
			return ( 100.0 + HardcodedData.prayers[pray_id]["modifiers"]["magic_attack"] ) / 100
	return 1.0

func _get_pray_rng() -> float:
	for pray_id in prayers:
		if not "modifiers" in HardcodedData.prayers[pray_id]:
			continue
		if "ranged" in HardcodedData.prayers[pray_id]["modifiers"]:
			return ( 100.0 + HardcodedData.prayers[pray_id]["modifiers"]["ranged"] ) / 100
	return 1.0

func _get_pray_rng_str() -> float:
	for pray_id in prayers:
		if not "modifiers" in HardcodedData.prayers[pray_id]:
			continue
		if "ranged_str" in HardcodedData.prayers[pray_id]["modifiers"]:
			return ( 100.0 + HardcodedData.prayers[pray_id]["modifiers"]["ranged_str"] ) / 100
	return 1.0

func _get_pray_rng_atk() -> float:
	for pray_id in prayers:
		if not "modifiers" in HardcodedData.prayers[pray_id]:
			continue
		if "ranged_attack" in HardcodedData.prayers[pray_id]["modifiers"]:
			return ( 100.0 + HardcodedData.prayers[pray_id]["modifiers"]["ranged_attack"] ) / 100
	return 1.0

