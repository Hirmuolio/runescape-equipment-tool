extends HBoxContainer

tool

export var  value : int = 0 setget _set_value
export var label : String = "Label" setget _set_label

signal value_changed(new_value)

func _ready():
	pass

func _set_label( new_label ):
	label = new_label
	$Label.text = new_label

func _set_value( new_value : int ):
	value = new_value
	$LineEdit.text = String(value)


func _on_input_focus_exited():
	$LineEdit.text = String(value)


func _on_LineEdit_text_changed(new_text):
	if( new_text.is_valid_integer() ):
		value = int(new_text)
		emit_signal("value_changed", value )
