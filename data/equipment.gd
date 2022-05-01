extends Node

class_name equipment
#func get_class(): return "equipment"

var item_name : String
var examine : String
var item_id : int
# weapon, 2h, ammo, cape, legs, body, shield, neck, head, feet, hands, ring, shield, spell
var equipment_slot : String

var two_handed : bool = false

# Stats
# stab, slash, crush, mage, range
var attack_stab : int
var attack_slash : int
var attack_crush : int
var attack_magic : int
var attack_ranged : int

var defence_stab : int
var defence_slash : int
var defence_crush : int
var defence_magic : int
var defence_ranged : int

var melee_strength : int
var ranged_strength : int
var magic_damage_bonus : int
var prayer : int

var attack_speed : int
var stances : Array

# Spells are items in here
var magic_max_hit : int

# Hardcoded attributes set during load
var special_effects : Array

# Current state in the list
var is_hidden = false



func is_identical( oth_item : equipment ) -> bool:
	
	if item_name != oth_item.item_name:
		return false
	
	if attack_stab != oth_item.attack_stab:
		return false
	if attack_slash != oth_item.attack_slash:
		return false
	if attack_crush != oth_item.attack_crush:
		return false
	if attack_magic != oth_item.attack_magic:
		return false
	if attack_ranged != oth_item.attack_ranged:
		return false
	
	if defence_stab != oth_item.defence_stab:
		return false
	if defence_slash != oth_item.defence_slash:
		return false
	if defence_crush != oth_item.defence_crush:
		return false
	if defence_magic != oth_item.defence_magic:
		return false
	if defence_ranged != oth_item.defence_ranged:
		return false
	
	if melee_strength != oth_item.melee_strength:
		return false
	if ranged_strength != oth_item.ranged_strength:
		return false
	if magic_damage_bonus != oth_item.magic_damage_bonus:
		return false
	if prayer != oth_item.prayer:
		return false
	
	if attack_speed != oth_item.attack_speed:
		return false
	
	# Comparing the stances causes false positives.
	#if stances != oth_item.stances:
	#	return false
	
	return true

func info()->String:
	return examine

