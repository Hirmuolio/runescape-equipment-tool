tool

extends HBoxContainer


export var slot : String setget _set_slot
var equipped_gear : equipment

signal remove_gear(slot)


func _ready():
	pass

func _set_slot( new_slot ):
	slot = new_slot
	$Label.text = slot.capitalize() + ":"

func add_gear( new_gear : equipment):
	if new_gear:
		equipped_gear = new_gear
		$Button.text = equipped_gear.item_name
	else:
		remove_gear()

func remove_gear():
	$Button.text = ""
	equipped_gear = null

func _on_Button_pressed():
	remove_gear()
	emit_signal("remove_gear", slot )



func _on_Button_mouse_entered():
	if equipped_gear:
		var hoover_node = load( "res://interface/hoover_info.tscn" ).instance()
		get_tree().get_root().add_child( hoover_node )
		hoover_node.initialize( $Button, equipped_gear.examine )
