extends HBoxContainer

@tool

@export var value : int = 0
@export var label : String = "Label" : set = _set_label

@export var hoover_info : String

signal value_changed(new_value)

func _ready():
	pass

func _set_label( new_label ):
	label = new_label
	$Label.text = new_label

func set_value( new_value : int ):
	value = new_value
	$LineEdit.text = str(value)


func _on_line_edit_focus_exited():
	$LineEdit.text = str(value)


func _on_LineEdit_text_changed(new_text):
	if( new_text.is_valid_int() ):
		value = int(new_text)
		emit_signal("value_changed", value )

func _on_CheckBox_mouse_entered():
	if hoover_info:
		var hoover_node = load( "res://interface/hoover_info.tscn" ).instantiate()
		get_tree().get_root().add_child( hoover_node )
		hoover_node.initialize( $CheckBox, hoover_info )

