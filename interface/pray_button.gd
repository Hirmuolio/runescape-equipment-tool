extends Button


var pray_id : String = "" : set = _set_pray_id
#var hoover_info : String


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _set_pray_id( new_pray_id ):
	pray_id = new_pray_id
	#hoover_info = HardcodedData.prayers[pray_id]["description"]
	text = HardcodedData.prayers[pray_id]["name"]
	pass


func _on_pray_button_mouse_entered():
	var hoover_node = load( "res://interface/hoover_info.tscn" ).instantiate()
	
	var hoover_info : String = HardcodedData.prayers[pray_id]["description"]
	hoover_info += "\ndrain: " + str( HardcodedData.prayers[pray_id]["drain"] )
	get_tree().get_root().add_child( hoover_node )
	hoover_node.initialize( self, hoover_info )

func remove_button():
	queue_free()
