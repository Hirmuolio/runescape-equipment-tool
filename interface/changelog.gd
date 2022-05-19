extends RichTextLabel




# Called when the node enters the scene tree for the first time.
func _ready():
	var changelog : String =""
	
	changelog += "0.7"
	changelog += "\n* Started tracking changelog"
	changelog += "\n* Added info window that shows info on the program"
	
	var _err = parse_bbcode ( changelog )


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
