extends VBoxContainer

signal prayer_selected( prayer_id )

func _ready():
	create_list()
	pass

func create_list():
	var pray_button_scene = preload( "res://interface/pray_button.tscn" )
	for prayer_id in HardcodedData.prayers.keys(): 
		var button = pray_button_scene.instantiate()
		add_child( button )
		
		button.pray_id = prayer_id
		button.connect("button_down",Callable(self,"_on_pray_selected").bind(prayer_id))


func _on_pray_selected( pray_id : String ):
	emit_signal("prayer_selected", pray_id )
