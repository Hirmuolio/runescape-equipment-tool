extends HBoxContainer

tool

export var  value : float = 0 setget _set_value
export var label : String = "Label" setget _set_label

export(String, MULTILINE) var hoover_info

func _ready():
	pass

func _set_label( new_label ):
	label = new_label
	$Label.text = new_label

func _set_value( new_value ):
	value = new_value
	$display.text = String(value)


func _on_display_mouse_entered():
	if hoover_info:
		var hoover_node = load( "res://interface/hoover_info.tscn" ).instance()
		get_tree().get_root().add_child( hoover_node )
		hoover_node.initialize( $display, hoover_info )
