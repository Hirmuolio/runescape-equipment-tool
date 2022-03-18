extends HBoxContainer

tool

export var  value : float = 0 setget _set_value
export var label : String = "Label" setget _set_label


func _ready():
	pass

func _set_label( new_label ):
	label = new_label
	$Label.text = new_label

func _set_value( new_value ):
	value = new_value
	$display.text = String(value)

