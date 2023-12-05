extends NinePatchRect

func _ready() -> void:
	#$RichTextLabel.default_color = Color( 0, 0, 0, 1 )
	pass # Replace with function body.

func initialize( source_node : Node, info_text : String ) -> void:
	var _err1 : int = source_node.connect("mouse_exited",Callable(self,"_delete"))
	var _err2 : int = source_node.connect("tree_exiting",Callable(self,"_delete"))
	
	$RichTextLabel.parse_bbcode( info_text )
	set_position( get_viewport().get_mouse_position() ) 
	

func _delete() -> void:
	queue_free()
