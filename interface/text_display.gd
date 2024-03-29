extends HBoxContainer

#@tool

@export var value : String = "" : set = _set_value
@export var label : String = "Label" : set = _set_label

var hoover_info : String

func _ready() -> void:
	pass

func _set_label( new_label : String ) -> void:
	label = new_label
	$Label.text = new_label

func _set_value( new_value : String ) -> void:
	value = new_value
	$display.text = value

func _on_mouse_entered() -> void:
	if hoover_info:
		var hoover_node : Node = load( "res://interface/hoover_info.tscn" ).instantiate()
		get_tree().get_root().add_child( hoover_node )
		hoover_node.initialize( self, hoover_info )

