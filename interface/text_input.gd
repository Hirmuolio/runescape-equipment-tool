@tool

extends HBoxContainer

@export var label : String = "" : set = _set_label

signal text_changed( new_text : String )

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _set_label( new_label : String ) -> void:
	label = new_label
	$Label.text = new_label

func set_text( new_text :String ) -> void:
	$LineEdit.text = new_text


func _on_LineEdit_text_changed(new_text : String) -> void:
	emit_signal( "text_changed", new_text )
