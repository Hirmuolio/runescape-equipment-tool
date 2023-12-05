extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var changelog : String ="CHANGELOG\n"
	
	changelog += "--0.9--"
	changelog += "\n- Godot 4 (beta)"
	changelog += "\n- Crystal armor"
	
	changelog += "--0.8--"
	changelog += "\n- Godot 3.5"
	changelog += "\n- Bugfixes"
	changelog += "\n- Salamanders"
	changelog += "\n- Colossal blade"
	changelog += "\n- Holy water"
	changelog += "\n- Brinstone ring"
	changelog += "\n- Fixed Osmuten's fang calculations"
	changelog += "\n- Tumeken's shadow"
	changelog += "\n- Keris variants"
	changelog += "\n- Blowpipes"
	
	changelog += "\n\n--0.7--"
	changelog += "\n- Started tracking changelog"
	changelog += "\n- Added this info window that tells you about this info window"
	changelog += "\n- Upgraded from Godot 3.4.4 to Godot 3.5 RC-8"
	changelog += "\n- Added scroolbars. The UI is now usable on smaller window sizes."
	changelog += "\n- Added Dragon warhammer spec."
	changelog += "\n- Prayer improvements and prayer drain."
	changelog += "\n- Bugfixes."
	
	parse_bbcode( changelog )

