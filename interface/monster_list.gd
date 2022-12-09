extends VBoxContainer


var root
var search_active : bool = false
var group_collapsed : Dictionary

signal item_selected( monster_node )

func _ready():
	create_tree()
	pass

func create_tree():
	# Creates full tree
	
	
	$Tree.clear()
	root = $Tree.create_item()
	
	for _monster in Database.get_monsters(): 
		var mon : monster = _monster # Dirty hack to get typing
		if mon.is_hidden:
			continue
		
		var tree_item = $Tree.create_item( root )
		tree_item.set_text(0, mon.monster_name + " " + str(mon.combat_level) )
		tree_item.set_metadata(0, mon)




func filter( search_term : String ):
	
	for child in get_children():
		child.filter( search_term )
	
	for child in get_children():
		child.hide_if_empty()


func _on_search_text_changed(search_term):
	
	var do_search : bool = search_term.length() > Config.min_search_length
	
	if !do_search && !search_active:
		return
	
	search_active = do_search
	
	print( search_term )
	
	for _monster in Database.get_monsters(): 
		var mon : monster = _monster # Dirty hack to get typing
		if !search_active:
			mon.is_hidden = false
		elif Config.search_mode == 0 and mon.monster_name.findn(search_term) > -1:
			mon.is_hidden = false
		elif Config.search_mode == 1 and mon.monster_name.matchn(search_term):
			mon.is_hidden = false
		elif Config.search_mode == 2 and search_term.is_subsequence_ofn(mon.monster_name):
			mon.is_hidden = false
		elif Config.search_mode > 2:
			print( "Invalid search methord")
			mon.is_hidden = false
		else:
			mon.is_hidden = true
	
	create_tree()


func _on_Tree_cell_selected():
	var selected : TreeItem = $Tree.get_selected()
	selected.deselect(0)
	if typeof( selected.get_metadata(0) ) == TYPE_STRING:
		# Group collapse/expand
		selected.collapsed = !selected.collapsed
		group_collapsed[selected.get_metadata(0) ] = selected.collapsed
	else:
		emit_signal("item_selected", selected.get_metadata(0) )

