extends HBoxContainer

tool

export var  value : String = "" setget _set_value
export var label : String = "Label" setget _set_label


func _ready():
	pass

func _set_label( new_label : String ):
	label = new_label
	$Label.text = new_label

func _set_value( new_value : String ):
	value = new_value
	$display.text = value

