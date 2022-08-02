extends RichTextLabel




# Called when the node enters the scene tree for the first time.
func _ready():
	var changelog : String ="CHANGELOG\n"
	
	changelog += "--0.7--"
	changelog += "\n- Started tracking changelog"
	changelog += "\n- Added this info window that tells you about this info window"
	changelog += "\n- Upgraded from Godot 3.4.4 to Godot 3.5"
	changelog += "\n- Added scroolbars. The UI is now usable on smaller window sizes."
	
	var _err = parse_bbcode ( changelog )


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
