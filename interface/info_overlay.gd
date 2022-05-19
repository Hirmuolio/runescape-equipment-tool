extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var info_text : String = ""
	
	info_text += "Runescape Equipment Tool"
	
	var ret_version : String = "0.7"
	info_text += " v" + ret_version
	
	info_text += "\nGodot version: " + Engine.get_version_info().string
	
	info_text += "[url]https://github.com/Hirmuolio/runescape-equipment-tool[/url]"
	
	
	$HBoxContainer/VBoxContainer/info.parse_bbcode ( info_text )


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_info_pressed():
	visible = !visible 


func _on_info_meta_clicked(meta):
	OS.shell_open(meta)




func _on_Button_pressed():
	visible = !visible
