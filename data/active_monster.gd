extends Node

#class_name monster
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
var magic_bonus : int = 0 # damage bonus
var attack_ranged : int = 0 # accuracy
var ranged_bonus : int = 0 # damage

var max_hit : int = 1

var defence_stab : int = 0
var defence_slash : int = 0
var defence_crush : int = 0
var defence_magic : int = 0
var defence_ranged : int = 0

var attack_type : Array
var attack_speed : int

var attributes : Array
var size : int = 1

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
