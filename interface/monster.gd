extends VBoxContainer


var current_monster : monster

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_monster( monster_node : monster ):
	if !monster_node:
		# Tried to set monster to null
		return
	current_monster = monster_node
	$name.text = current_monster.monster_name + " (lvl " + str(current_monster.combat_level) + ")"
	$description.text = current_monster.examine
	
	$health.value = current_monster.hitpoints
	$attack.value = current_monster.attack_level
	$strength.value = current_monster.strength_level
	$defence.value = current_monster.defence_level
	$magic.value = current_monster.magic_level
	$ranged.value = current_monster.ranged_level
	
	$style.value = str(current_monster.attack_type).trim_prefix ( "[" ).trim_suffix("]")
	$speed.value = current_monster.attack_speed
	$max_hit.value = current_monster.max_hit
	$atk_bonus.value = current_monster.attack_bonus
	$str_bonus.value = current_monster.strength_bonus
	$mage_bonus.value = current_monster.attack_magic
	$mage_str_bonus.value = current_monster.str_magic
	$rng_bonus.value = current_monster.attack_ranged
	$rng_str_bonus.value = current_monster.str_ranged
	
	$def_stab.value = current_monster.defence_stab
	$def_slash.value = current_monster.defence_slash
	$def_crush.value = current_monster.defence_crush
	$def_mage.value = current_monster.defence_magic
	$def_range.value = current_monster.defence_ranged
	
	$attributes.value = str(current_monster.attributes).trim_prefix ( "[" ).trim_suffix("]")
	$size.value = str( current_monster.size )
	
	pass
