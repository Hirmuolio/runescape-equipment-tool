extends NinePatchRect

func _ready():
	#$RichTextLabel.default_color = Color( 0, 0, 0, 1 )
	pass # Replace with function body.

func initialize( source_node : Node, info_text : String ):
	var _err = source_node.connect("mouse_exited", self, "_delete")
	
	$RichTextLabel.parse_bbcode( info_text )
	set_position( get_viewport().get_mouse_position() ) 
	
	# Set the box size to fit the contained text
	# get_content_height() seems to be bugged so we need to wait for a second before calling it
	yield(get_tree().create_timer(.01), "timeout")
	var height = $RichTextLabel.get_content_height()
	rect_min_size.y = max( height, 50 )
	

func _delete():
	queue_free()
