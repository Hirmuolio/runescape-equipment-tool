extends HBoxContainer

#@tool

@export var value : bool = false : set = _set_value
@export var label : String = "Label" : set = _set_label

@export var hoover_info : String

signal value_changed(new_value)

func _ready() -> void:
	$Label.text = label
	pass

func _set_label( new_label : String ) -> void:
	label = new_label
	$Label.text = new_label

func _set_value( new_value : bool ) -> void:
	value = new_value
	$CheckBox.button_pressed = new_value

func _on_CheckBox_pressed() -> void:
	emit_signal("value_changed", $CheckBox.button_pressed )


func _on_CheckBox_mouse_entered() -> void:
	if hoover_info:
		var hoover_node = load( "res://interface/hoover_info.tscn" ).instantiate()
		get_tree().get_root().add_child( hoover_node )
		hoover_node.initialize( $CheckBox, hoover_info )

