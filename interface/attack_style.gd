extends OptionButton


var options : Array
signal attack_style( new_stance : Array )


func _ready() -> void:
	pass # Replace with function body.


func set_slection( item : equipment) -> void:
	clear()
	options = []
	if item.stances.size() != 0:
		for stance : Dictionary in item.stances:
			if stance["attack_style"]:
				options.append( [ stance["attack_style"], stance["attack_type"] ] )
			elif stance["combat_style"]:
				var wp_stance : String = stance["combat_style"]
				var style : String = "ranged"
				
				if "powered_staff" in HardcodedData.specials_of_item( item ):
					style = "magic"
				
				# Salamander stuff
				if stance["combat_style"] == "scorch":
					style = "slash"
					wp_stance = "aggressive"
				elif stance["combat_style"] == "flare":
					style = "ranged"
					wp_stance = "accurate"
				elif stance["combat_style"] == "blaze":
					style = "defensive"
					wp_stance = "magic"
				
				options.append( [ wp_stance, style ] )
	else:
		# Defaults for item with no valid attack stances
		options = [ 
			["accurate", "stab"],
			["accurate", "slash"],
			["accurate", "crush"],
		]
		
	for option : Array in options:
		add_item( option[0] + " (" + option[1] + ")")
	
	emit_signal( "attack_style", options[0] )


func _on_attack_style_item_selected(index : int) -> void:
	print( options[index] )
	emit_signal( "attack_style", options[index] )
