extends Node

class_name player
#func get_class(): return "player"

signal gear_change( slot, new_gear )

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


# slash, crush, stab, magic, ranged
var attack_style : String = "crush"

# aggressive, defensive, accurate, controlled
# rapid, long range, accurate
# spellcasting, defensive casting
var attack_stance : String


# Dynamically calculated attributes:
var str_bonus : int setget ,_get_str_bonus
var atk_bonus : int setget ,_get_atk_bonus

var prayer_str : float setget ,_get_pray_str
var prayer_atk : float setget ,_get_pray_att
var prayer_def : float setget ,_get_pray_def

var style_str_bonus : int setget ,_get_style_str
var style_atk_bonus : int setget ,_get_style_atk
var style_def_bonus : int setget ,_get_style_def

var other_str_bonus : float = 1 #TODO
var other_atk_bonus : float = 1 #TODO
var other_def_bonus : float = 1 #TODO

var attack_speed : int setget ,_get_attack_speed

var prayers : Array = []
var special_attributes : Array = []

func set_specials():
	# Determines what special attributes the equipment has
	# Takes into account conflicts and set requirements
	
	special_attributes = []
	
	# All specials with duplicates
	var all_specials : Dictionary = {}
	
	for item in all_equipped():
		for special in HardcodedData.specials_of_item( item ):
			if special in all_specials:
				all_specials[special] = all_specials[special] + 1
			else:
				all_specials[special] = 1
	
	for special in all_specials.keys():
		if "set" in HardcodedData.equipment_specials[special]:
			if all_specials[special] < HardcodedData.equipment_specials[special]["set"]:
				continue
		if !special_attributes.has( special ):
			special_attributes.append( special )

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

func prayer_add( prayer_id : String ) -> bool:
	# Returns true if prayer was added
	if prayer_id in prayers:
		return false
	
	# Can't have multiple prayers modify same stat
	# Not good check. TODO make better
	var already_modified : Array = []
	for pra in prayers:
		already_modified.append_array( HardcodedData.prayers[pra]["modifiers"].keys() )
	for mod in HardcodedData.prayers[prayer_id]["modifiers"].keys():
		if mod in already_modified:
			return false
	
	prayers.append( prayer_id )
	recalculate_stats()
	return true

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


func _on_attack_style_attack_style(new_stance):
	attack_stance = new_stance[0]
	attack_style = new_stance[1]
	pass # Replace with function body.

func _get_style_str() -> int:
	if attack_stance == "aggressive":
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
	
	push_warning ( "Invalid weapon melee attack style " + '"' + attack_style + '"' )
	return get_equipment_bonus( "attack_stab" )

func style_def( attack_styles : Array ) -> int:
	
	if attack_styles[0] == "stab":
		return get_equipment_bonus( "defence_stab" )
	elif attack_styles[0] == "slash":
		return get_equipment_bonus( "defence_slash" )
	elif attack_styles[0] == "crush":
		return get_equipment_bonus( "defence_crush" )
	
	push_warning ( "Invalid monster melee attack style " + '"' + attack_styles[0] + '"' )
	return 0

func _get_attack_speed() -> int:
	# Ticks per attack
	if weapon:
		return weapon.attack_speed
	return 5

func _get_pray_str() -> float:
	for pray_id in prayers:
		if "strength" in HardcodedData.prayers[pray_id]["modifiers"]:
			return ( 100.0 + HardcodedData.prayers[pray_id]["modifiers"]["strength"] ) / 100
	return 1.0

func _get_pray_att() -> float:
	for pray_id in prayers:
		if "attack" in HardcodedData.prayers[pray_id]["modifiers"]:
			return ( 100.0 + HardcodedData.prayers[pray_id]["modifiers"]["attack"] ) / 100
	return 1.0

func _get_pray_def() -> float:
	for pray_id in prayers:
		if "defence" in HardcodedData.prayers[pray_id]["modifiers"]:
			return ( 100.0 + HardcodedData.prayers[pray_id]["modifiers"]["defence"] ) / 100
	return 1.0
