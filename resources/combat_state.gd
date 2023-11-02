extends Resource
class_name combat_state
# Compact resource that holds all the things needed for combat simulation
# Holds precalculated variables for speed benefits
# Holds values that may changeduring fight

var rng : RandomNumberGenerator

var m_def_roll : int = 0
var p_hit_roll : int = 0

var attack_speed : int = 0

var p_post_roll_max : int = 0 # Max hit after post-roll modifiers
var p_max_hit : int = 0
# Post roll multiplier applied after damage is rolled. Only tome of fire, tome of water, demonbane and castle wars bracelet
# Floats would result in different rounding errors
# So multipliers are stored as interger numerator/denominator pairs
var post_roll_mult : Vector2i = Vector2i(1,1)

var crit_chance : float = 0
var p_crit_max_hit : int = 0
var p_post_rollcrit : int = 0

var zaryte : bool = false # Is using zaryte crossbow
var kandarin : float = 1 # Multiplier to bolt (e) proc chance. x1.1 when diary completed
var toa : bool = false # Are we in tombs of amascut?
var brimstone : bool = false # Brimstone ring

var target_hp : int = 0
var target_max_hp : int = 0
var fiery : bool = false # Is target fiery

var p_ranged : int = 0 #player ranged lvl

func reset():
	m_def_roll = 0
	p_hit_roll = 0
	attack_speed = 0
	p_max_hit = 0
	crit_chance = 0
	p_crit_max_hit = 0
	zaryte = false
	kandarin = 1
	toa = false
	brimstone = false
	target_hp = 0
	target_max_hp = 0
	fiery = false
	p_ranged = 0
	post_roll_mult = Vector2i(0,0)
	p_post_rollcrit = 0

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