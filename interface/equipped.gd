@tool

extends HBoxContainer


@export var slot : String = "" : set = _set_slot
var equipped_gear : equipment

signal removed_gear(slot)


func _ready() -> void:
	pass

func _set_slot( new_slot ) -> void:
	slot = new_slot
	$Label.text = slot.capitalize() + ":"

func add_gear( new_gear : equipment) -> void:
	if new_gear:
		equipped_gear = new_gear
		$Button.text = equipped_gear.item_name
	else:
		remove_gear()

func remove_gear() -> void:
	$Button.text = ""
	equipped_gear = null

func _on_Button_pressed() -> void:
	remove_gear()
	emit_signal("removed_gear", slot )



func _on_Button_mouse_entered() -> void:
	if equipped_gear:
		var hoover_node = load( "res://interface/hoover_info.tscn" ).instantiate()
		get_tree().get_root().add_child( hoover_node )
		hoover_node.initialize( $Button, equipped_gear.examine )
