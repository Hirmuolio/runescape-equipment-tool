extends Resource
class_name combat_state
# Compact resource that holds all the things needed for combat simulation
# Holds precalculated variables for speed benefits
# Holds values that may changeduring fight

var rng : RandomNumberGenerator

var m_def_roll : int = 0
var p_hit_roll : int = 0

var attack_speed : int = 0

var p_max_hit : int = 0

var crit_chance : float = 0
var p_crit_max_hit : int = 0

var zaryte : bool = false # Is using zaryte crossbow
var kandarin : float = 1 # Multiplier to bolt (e) proc chance. x1.1 when diary completed
var toa : bool = false # Are we in tombs of amascut?
var brimstone : bool = false # Brimstone ring

var target_hp : int = 0
var target_max_hp : int = 0
var fiery : bool = false # Is target fiery

var p_ranged : int = 0 #player ranged lvl

func is_dead():
	return target_hp <= 0

func revive():
	target_hp = target_max_hp

func chance( probability : float ) -> bool:
	# probability is percentage chance in decimal form. Example: 25% = 0.25
	return rng.randf() <= probability

func rng_roll( max_value : int ) -> int:
	# Rolls random number 0-max_value (inclusively)
	return rng.randi_range( 0, max_value )
