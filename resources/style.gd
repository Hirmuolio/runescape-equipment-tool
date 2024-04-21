extends Resource
class_name attack_style

# Name of the combat style. Cosmetic
var combat_style : String

enum enum_types { SLASH, CRUSH, STAB, MAGIC, RANGED, NONE, TYPELESS = -1 }
enum enum_stances { AGGRESSIVE, DEFENSIVE, ACCURATE, CONTROLLED, ACCURATE_RANGED, RAPID, LONGRANGE, SPELLCASTING, SPELLCASTING_DEF, ACCURATE_MAGIC, LONGRANGE_MAGIC }

var attack_type : enum_types
var attack_stance : enum_stances

func load_dictionary( stance_dic : Dictionary )->void:
	combat_style = stance_dic["combat_style"]
	
	# Horrible mess because this shit is not standardized and some items have bad values
	
	if stance_dic["attack_type"] == "spellcasting":
		attack_type = enum_types.MAGIC
	elif stance_dic["attack_style"] == "magic":
		attack_type = enum_types.MAGIC
	elif stance_dic["experience"] == "magic":
		attack_type = enum_types.MAGIC
	elif stance_dic["experience"] == "magic and defence":
		attack_type = enum_types.MAGIC
	elif stance_dic["combat_style"] == "block" and stance_dic["experience"] == null:
		# Dinh's bulwark
		attack_type = enum_types.NONE
	elif stance_dic["attack_type"] != null:
		attack_type = enum_types.get( stance_dic["attack_type"].to_upper() )
	elif stance_dic["experience"] == "ranged" or stance_dic["experience"] == "ranged and defence":
		attack_type = enum_types.RANGED
	else:
		assert(false, "NO ATTACK TYPE")
	
	# Salamanders don't have this info in the json
	if stance_dic["combat_style"] == "scorch":
		attack_stance = enum_stances.AGGRESSIVE
	elif stance_dic["combat_style"] == "flare":
		attack_stance = enum_stances.ACCURATE_RANGED
	elif stance_dic["combat_style"] == "blaze":
		attack_stance = enum_stances.LONGRANGE_MAGIC
	elif stance_dic["combat_style"] == "spell":
		attack_stance = enum_stances.SPELLCASTING
	elif stance_dic["combat_style"] == "spell (defensive)":
		attack_stance = enum_stances.SPELLCASTING_DEF
	elif stance_dic["attack_style"] != null:
		attack_stance = enum_stances.get( stance_dic["attack_style"].to_upper() )
	else:
		# Supid values in wrong places in json
		if stance_dic["combat_style"] == "accurate":
			attack_stance = enum_stances.ACCURATE_RANGED
		elif stance_dic["combat_style"] == "rapid":
			attack_stance = enum_stances.RAPID
		elif stance_dic["combat_style"] == "longrange":
			attack_stance = enum_stances.LONGRANGE

func get_style_string()->String:
	var ret : String = enum_stances.keys()[attack_stance].to_lower() + " (" + enum_types.keys()[attack_type].to_lower() + ")"
	return ret

func type2st()->String:
	return enum_types.keys()[attack_type].to_lower()


func get_style_str() -> int:
	if attack_stance == enum_stances.AGGRESSIVE:
		return 3
	elif attack_stance == enum_stances.CONTROLLED:
		return 1
	return 0

func get_style_atk() -> int:
	if attack_stance == enum_stances.ACCURATE:
		return 3
	elif attack_stance == enum_stances.CONTROLLED:
		return 1
	return 0

func get_style_def() -> int:
	# I do not know if defensive autocasting gives def bonus but lets assume it does not
	if attack_stance in [ enum_stances.DEFENSIVE, enum_stances.LONGRANGE, enum_stances.LONGRANGE_MAGIC ]:
		return 3
	elif attack_stance == enum_stances.CONTROLLED:
		return 1
	return 0

func get_style_rng() -> int:
	if attack_stance == enum_stances.ACCURATE_RANGED:
		return 3
	return 0

func get_style_mag() -> int:
	if attack_stance in [enum_stances.ACCURATE_MAGIC, enum_stances.ACCURATE_RANGED]:
		return 2
	return 0

func is_block() -> bool:
	return attack_stance == enum_stances.DEFENSIVE

func is_magic() -> bool:
	return attack_type == enum_types.MAGIC

func is_ranged() -> bool:
	return attack_type == enum_types.RANGED

func is_crush() -> bool:
	return attack_type == enum_types.CRUSH

