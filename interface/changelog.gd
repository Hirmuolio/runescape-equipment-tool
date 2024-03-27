extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var file := FileAccess.open("res://changelog.txt", FileAccess.READ)
	var content : String = file.get_as_text()
	
	parse_bbcode( content )

