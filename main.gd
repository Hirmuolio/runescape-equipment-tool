extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_low_processor_usage_mode(true)
	#ProjectSettings.set_setting("gui/theme/default_font_antialiasing", "Grayscale")
	ProjectSettings.set_setting("application/config/gui/theme/lcd_subpixel_layout", "Horizontal RGB")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
