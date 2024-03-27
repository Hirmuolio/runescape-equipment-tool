extends Resource
class_name combat_state
# Compact resource that holds all the things needed for combat simulation
# Holds precalculated variables for speed benefits
# Holds values that may changeduring fight

var rng : RandomNumberGenerator

# Simulation duration in ticks
var duration : int = 0

var monster_def_roll : int = 0
var player_atk_roll : int = 0

var attack_speed : int = 0

#var max_hit : int = 0 # Max hit after post-roll modifiers
var crit_chance : float = 0
#var max_critical : int = 0

# Post roll multiplier applied after damage is rolled. Only tome of fire, tome of water, demonbane and castle wars bracelet
# Floats would result in different rounding errors
# So multipliers are stored as interger numerator/denominator pairs
var post_roll_mult : Vector2i = Vector2i(1,1)
var pre_roll_max : int = 0
var pre_roll_crit : int = 0

var zaryte : bool = false # Is using zaryte crossbow
var kandarin : float = 1 # Multiplier to bolt (e) proc chance. x1.1 when diary completed
var toa : bool = false # Are we in tombs of amascut?
var brimstone : bool = false # Brimstone ring
var armour : int = 0 # flat damage bonus applied per hit

var target_hp : int = 0
var target_max_hp : int = 0

var burn_last_applied : int = 0 # Tick on which burn was last applied
var burn_stack : Array[int] # Burn effect from eclipse set

var fiery : bool = false # Is target fiery

var bloodrager : bool = false # Bloodrager set effect
var p_ranged : int = 0 #player ranged lvl

func initialize( act_player : player, target_mon : monster, stats : dps_stats ) -> void:
	rng = RandomNumberGenerator.new()
	rng.randomize()
	target_max_hp = target_mon.hitpoints
	monster_def_roll = stats.monster_def_roll
	player_atk_roll = stats.player_atk_roll
	#max_hit = stats.max_hit
	post_roll_mult = stats.post_roll_mult
	pre_roll_max = stats.pre_roll_max
	pre_roll_crit = stats.pre_roll_crit
	#max_critical = stats.max_critical
	attack_speed = act_player.attack_speed
	fiery = "fiery" in target_mon.attributes

func is_dead() -> bool:
	return target_hp <= 0

func revive() -> void:
	target_hp = target_max_hp

func chance( probability : float ) -> bool:
	# probability is percentage chance in decimal form. Example: 25% = 0.25
	return rng.randf() <= probability

func rng_roll( max_value : int ) -> int:
	# Rolls random number 0-max_value (inclusively)
	return rng.randi_range( 0, max_value )
