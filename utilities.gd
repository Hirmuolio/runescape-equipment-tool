extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func ifloor( number : float ) -> int:
	# Returns floor as integer
	return int( floor( number) )
