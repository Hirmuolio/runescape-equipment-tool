extends OptionButton


var options : Array
signal style_changed( new_stance : attack_style )


func _ready() -> void:
	pass # Replace with function body.


func set_slection( item : equipment) -> void:
	clear()
	options = item.stances
	for stance : attack_style in item.stances:
		add_item( stance.get_style_string() )
	
	style_changed.emit( item.stances[0] )


func _on_attack_style_item_selected(index : int) -> void:
	style_changed.emit( options[index] )
