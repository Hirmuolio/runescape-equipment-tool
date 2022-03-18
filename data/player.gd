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

var prayer_str : float = 1 #TODO
var prayer_atk : float = 1 #TODO
var prayer_def : float = 1 #TODO

var style_str_bonus : int setget ,_get_style_str
var style_atk_bonus : int setget ,_get_style_atk
var style_def_bonus : int setget ,_get_style_def

var other_str_bonus : float = 1 #TODO
var other_atk_bonus : float = 1 #TODO
var other_def_bonus : float = 1 #TODO

var attack_speed : int setget ,_get_attack_speed

func recalculate_stats():
	pass

func equip( new_item : equipment  ):
	if new_item.equipment_slot == "2h":
		weapon = new_item
		shield = null
		emit_signal("gear_change", "weapon", new_item)
		emit_signal("gear_change", "shield", null)
	else:
		set( new_item.equipment_slot, new_item)
		emit_signal("gear_change", new_item.equipment_slot, new_item)
	recalculate_stats()



func _on_remove_gear(slot : String):
	if slot == "2h":
		weapon = null
	else:
		set( slot, null)
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
