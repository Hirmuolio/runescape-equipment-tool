extends Button


var pray_id : String setget _set_pray_id
var hoover_info : String


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _set_pray_id( new_pray_id ):
	pray_id = new_pray_id
	hoover_info = HardcodedData.prayers[pray_id]["description"]
	text = HardcodedData.prayers[pray_id]["name"]
	pass


func _on_pray_button_mouse_entered():
	return
	# This does not work right
	var hoover_node = load( "res://interface/hoover_info.tscn" ).instance()
	get_tree().get_root().add_child( hoover_node )
	hoover_node.initialize( self, hoover_info )

func remove_button():
	queue_free()
