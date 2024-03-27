extends Control


func _ready() -> void:
	var info_text : String = ""
	
	info_text += "Runescape Equipment Tool"
	var ret_version : String = "0.8.0"
	info_text += " v" + ret_version
	
	info_text += " [url]https://github.com/Hirmuolio/runescape-equipment-tool[/url]"
	
	info_text += "\n\nGodot version: " + Engine.get_version_info().string
	
	
	$HBoxContainer/VBoxContainer/info.parse_bbcode ( info_text )



func _on_info_pressed() -> void:
	visible = !visible 


func _on_info_meta_clicked(meta : String ) -> void:
	var _err : int = OS.shell_open(meta)


func _on_Button_pressed() -> void:
	visible = !visible
