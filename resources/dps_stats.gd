extends Resource
class_name dps_stats

var atk_roll : int = 0
var def_roll : int = 0

var max_hit : int = 0
var max_critical : int = 0

var post_roll_mult : Vector2i = Vector2i(1,1)
var post_roll_max : int = 0
var post_roll_crit : int = 0

var hit_chance : float = 0
var hit_chance_simulated : float = 0

var dps : float = 0
var dps_simulated : float = 0

var ttk : float = 0

var monster_max_hit : int = 0
var monster_hit_chance : float = 0

var monster_hit_roll : int = 0
var monster_def_roll : int = 0

var monster_dps : float = 0
