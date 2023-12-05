extends HBoxContainer

#@tool

@export var value : float = 0.0 : set = _set_value
@export var label : String = "Label" : set = _set_label

@export_multiline  var hoover_info : String = ""

func _ready() -> void:
	pass

func _set_label( new_label ) -> void:
	# This is bad and should not work. But it does work
	label = new_label
	$Label.text = new_label

func _set_value( new_value ) -> void:
	# This is bad and should not work. But it does work
	value = new_value
	$display.text = str(value)


func _on_display_mouse_entered() -> void:
	if hoover_info:
		var hoover_node = load( "res://interface/hoover_info.tscn" ).instantiate()
		get_tree().get_root().add_child( hoover_node )
		hoover_node.initialize( $display, hoover_info )
