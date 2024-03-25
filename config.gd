extends Node

const config_path : String = "user://settings.cfg"
var config := ConfigFile.new()


# Search
var search_display_mode : int = 0 # 0 = ungrouped, 1=top grouped, 2=grouoped
var min_search_length : int = 2
var search_mode : int = 2 # 0 = findn(), 1 = matchn() exact match, 2 = is_subsequence_ofi()


func _ready() -> void:
	return
	# Not using config file
#	var err = config.load( config_path )
#	if err == OK:
#		load_config()
#	else:
#		print( "No config file found. Using defaults.")
#		save_config()


func load_config() -> void:
	search_display_mode = config.get_value("search", "search_display_mode", 0)
	min_search_length = config.get_value("search", "min_search_length", 2)
	search_mode = config.get_value("search", "search_mode", 2)

func save_config() -> void:
	config.set_value("search", "search_display_mode", search_display_mode)
	config.set_value("search", "min_search_length", min_search_length)
	config.set_value("search", "search_mode", search_mode)
	var _error : int = config.save( config_path )
