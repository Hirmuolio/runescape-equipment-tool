extends VBoxContainer


var root : TreeItem
var search_active : bool = false
var group_collapsed : Dictionary

signal item_selected( item_node )

func _ready() -> void:
	create_tree()
	pass

func create_tree() -> void:
	# Creates full tree
	
	
	$Tree.clear()
	root = $Tree.create_item()
	
	# Create equipment categories
	# And add all their items
	#var groups : Array = [ "weapon", "2h", "ammo", "cape", "legs", "body", "head", "shield", "neck", "head", "feet", "hands", "ring", "shield" ]
	var tree_groups : Dictionary = {}
	for _item in Database.get_items(): 
		var item : equipment = _item # Dirty hack to get typing
		if item.is_hidden:
			continue
		var tree_group : TreeItem
		if !item.equipment_slot in tree_groups:
			tree_group = $Tree.create_item( root )
			tree_group.set_text(0, item.equipment_slot )
			if !item.equipment_slot in group_collapsed:
				tree_group.collapsed = true
				group_collapsed[item.equipment_slot] = true
			else:
				tree_group.collapsed = group_collapsed[item.equipment_slot]
			tree_group.set_metadata(0, item.equipment_slot)
			tree_groups[item.equipment_slot] = tree_group
		else:
			tree_group = tree_groups[item.equipment_slot]
		
		var tree_item : TreeItem = $Tree.create_item( tree_group )
		tree_item.set_text(0, item.item_name )
		tree_item.set_metadata(0, item)
		tree_item.set_tooltip_text( 0, item.info() )




func filter( search_term : String ) -> void:
	
	for child in get_children():
		child.filter( search_term )
	
	for child in get_children():
		child.hide_if_empty()


func _on_search_text_changed(search_term) -> void:
	
	var do_search : bool = search_term.length() >= Config.min_search_length
	
	if !do_search && !search_active:
		return
	
	search_active = do_search
	
	print( search_term )
	
	for _item in Database.get_items(): 
		var item : equipment = _item # Dirty hack to get typing
		if !search_active:
			item.is_hidden = false
		elif Config.search_mode == 0 and item.item_name.findn(search_term) > -1:
			item.is_hidden = false
		elif Config.search_mode == 1 and item.item_name.matchn(search_term):
			item.is_hidden = false
		elif Config.search_mode == 2 and search_term.is_subsequence_ofn(item.item_name):
			item.is_hidden = false
		elif Config.search_mode > 2:
			print( "Invalid search methord")
			item.is_hidden = false
		else:
			item.is_hidden = true
	
	create_tree()


func _on_Tree_cell_selected() -> void:
	var selected : TreeItem = $Tree.get_selected()
	selected.deselect(0)
	if typeof( selected.get_metadata(0) ) == TYPE_STRING:
		# Group collapse/expand
		selected.collapsed = !selected.collapsed
		group_collapsed[selected.get_metadata(0) ] = selected.collapsed
	else:
		emit_signal("item_selected", selected.get_metadata(0) )
