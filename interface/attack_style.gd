extends OptionButton


var options : Array
signal attack_style( new_stance )


func _ready():
	pass # Replace with function body.


func set_slection( item : equipment):
	clear()
	options = []
	if item.stances.size() != 0:
		for stance in item.stances:
			if stance["attack_style"]:
				options.append( [ stance["attack_style"], stance["attack_type"] ] )
			elif stance["combat_style"]:
				options.append( [ stance["combat_style"], "ranged" ] )
	else:
		options = [ 
			["accurate", "stab"],
			["accurate", "slash"],
			["accurate", "crush"],
		]
		
	for option in options:
		add_item( option[0] + " (" + option[1] + ")")
	
	emit_signal( "attack_style", options[0] )


func _on_attack_style_item_selected(index):
	print( options[index] )
	emit_signal( "attack_style", options[index] )
