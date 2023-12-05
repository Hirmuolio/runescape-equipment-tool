extends VBoxContainer

signal prayer_selected( prayer_id : String )

func _ready() -> void:
	create_list()
	pass

func create_list() -> void:
	var pray_button_scene : Resource = preload( "res://interface/pray_button.tscn" )
	for prayer_id : String in HardcodedData.prayers.keys(): 
		var button : Button = pray_button_scene.instantiate()
		add_child( button )
		
		button.pray_id = prayer_id
		button.connect("button_down",Callable(self,"_on_pray_selected").bind(prayer_id))


func _on_pray_selected( pray_id : String ) -> void:
	emit_signal("prayer_selected", pray_id )
