extends Node

class_name monster
#func get_class(): return "player"

var monster_name : String
var monster_id : int

# Levels
var attack_level : int = 1
var strength_level : int = 1
var magic_level : int = 1
var ranged_level : int = 1
var defence_level : int = 1
var hitpoints : int = 1

var combat_level : int = 1

# Stats
var attack_bonus : int = 0
var strength_bonus : int = 0
var attack_magic : int = 0 # accuracy
var str_magic : int = 0 # damage bonus
var attack_ranged : int = 0 # accuracy
var str_ranged : int = 0 # damage

var max_hit : int = 1

var defence_stab : int = 0
var defence_slash : int = 0
var defence_crush : int = 0
var defence_magic : int = 0
var defence_ranged : int = 0

var attack_type : Array = []
var attack_speed : int = 1

var attributes : Array = []
var size : String = "1x1"

# Current state in the list
var is_hidden = false


func recalculate_stats():
	pass

func _on_attack_value_changed( new_lvl ):
	attack_level = new_lvl
	recalculate_stats()


func _on_strength_value_changed( new_lvl ):
	strength_level = new_lvl
	recalculate_stats()


func _on_defence_value_changed( new_lvl ):
	defence_level =  new_lvl
	recalculate_stats()


func _on_magic_value_changed( new_lvl ):
	magic_level = new_lvl
	recalculate_stats()


func _on_ranged_value_changed( new_lvl ):
	ranged_level = new_lvl
	recalculate_stats()

func _on_hitpoints_value_changed( new_lvl ):
	hitpoints = new_lvl
	recalculate_stats()

func is_identical( oth_monster : monster ) -> bool:
	if monster_name != oth_monster.monster_name:
		return false
	
	if attack_level != oth_monster.attack_level:
		return false
	if strength_level != oth_monster.strength_level:
		return false
	if magic_level != oth_monster.magic_level:
		return false
	if ranged_level != oth_monster.ranged_level:
		return false
	if defence_level != oth_monster.defence_level:
		return false
	if hitpoints != oth_monster.hitpoints:
		return false
	
	if combat_level != oth_monster.combat_level:
		return false
	
	if attack_bonus != oth_monster.attack_bonus:
		return false
	if strength_bonus != oth_monster.strength_bonus:
		return false
	if attack_magic != oth_monster.attack_magic:
		return false
	if str_magic != oth_monster.str_magic:
		return false
	if attack_ranged != oth_monster.attack_ranged:
		return false
	if str_ranged != oth_monster.str_ranged:
		return false
	
	if max_hit != oth_monster.max_hit:
		return false
	
	if defence_stab != oth_monster.defence_stab:
		return false
	if defence_slash != oth_monster.defence_slash:
		return false
	if defence_crush != oth_monster.defence_crush:
		return false
	if defence_magic != oth_monster.defence_magic:
		return false
	if defence_ranged != oth_monster.defence_ranged:
		return false
	
	if attack_type != oth_monster.attack_type:
		return false
	if attack_speed != oth_monster.attack_speed:
		return false
	if attributes != oth_monster.attributes:
		return false
	if size != oth_monster.size:
		return false
	
	return true

func style_def( style : String ):
	match style:
		"stab":
			return defence_stab
		"slash":
			return defence_slash
		"crush":
			return defence_crush
		"spellcasting":
			return defence_magic
		"defensive casting":
			return defence_magic
		"ranged":
			return defence_ranged
	pass

