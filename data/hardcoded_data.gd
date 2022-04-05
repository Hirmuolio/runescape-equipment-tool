extends Node


# Tells what items have specific special attribute
var equipment_specials : Dictionary = {
	"black_mask" : {
		"items": ["Black mask"],
		"targets": ["slayer"],
		"name": "Black mask",
		"description": "16.67% bonus to melee accuracy and damage against slayer target."
	},
	"black_mask_i" : {
		"items": ["Black mask (i)"],
		"targets": ["slayer"],
		"name": "Black mask (i)",
		"description": "16.67% bonus to melee accuracy and damage against slayer target.\n15% bonus to ranged accuracy, ranged damage, magic accuracy and magic damage."
	},
	"ivandis_flail": {
		"items": ["Ivandis flail"],
		"targets": ["vampyre"],
		"name": "Ivandis flail",
		"description": "20% damage bonus against vampyres."
	},
	"blisterwood_flail": {
		"items": ["Blisterwood flail"],
		"targets": ["vampyre"],
		"name": "Blisterwood flail",
		"description": "25% damage and 5% accuracy bonus against vampyres."
	},
	"salve": {
		"items": ["Salve amulet"],
		"targets": ["undead"],
		"name": "Salve amulet",
		"description": "16.67% melee damage and accuracy bonus against undead. Does not stack with black mask/slayer helmet."
	},
	"salve_e": {
		"items": ["Salve amulet (e)"],
		"targets": ["undead"],
		"name": "Salve amulet (e)",
		"description": "20% melee damage and accuracy bonus against undead. Does not stack with black mask/slayer helmet."
	},
	"salve_ei": {
		"items": ["Salve amulet(ei)"],
		"targets": ["undead"],
		"name": "Salve amulet (ei)",
		"description": "20% melee, magic and ranged damage and accuracy bonus against undead. Does not stack with black mask/slayer helmet."
	},
	"salve_i": {
		"items": ["Salve amulet(i)"],
		"targets": ["undead"],
		"name": "Salve amulet (i)",
		"description": "16.67% melee and ranged damage and accuracy bonus against undead.\n15% magic damage and accuracy bonus against undead (NOTE: Uncertain of magic bonus). Does not stack with black mask/slayer helmet."
	},
	"dharok": {
		"items": ["Dharok's helm", "Dharok's platebody", "Dharok's platelegs", "Dharok's greataxe"],
		"name": "Dharok's set",
		"description": "Damage increases based on missing health",
		"set": 4
	},
	"obsidian_armor": {
		"name": "Obsidian set",
		"items": ["Obsidian helmet", "Obsidian platebody", "Obsidian platelegs", "Toktz-xil-ek", "Toktz-xil-ak", "Tzhaar-ket-em", "Tzhaar-ket-om", "Toktz-mej-tal"],
		"description": "10% bonus to damage and accuracy of obsidian weapons",
		"set": 4
	},
	"berserk": {
		"items": ["Berserker necklace", "Toktz-xil-ek", "Toktz-xil-ak", "Tzhaar-ket-em", "Tzhaar-ket-om", "Toktz-mej-tal"],
		"name": "Berserker necklace",
		"description": "20% bonus to damage of obsidian weapons",
		"set": 2
	},
	"viggora": {
		"items": ["Viggora's chainmace"],
		"name": "Viggora's chainmace)",
		"description": "50% bonus to melee damage amd accuracy in wilderness (only in PvE)",
	},
	"keris": {
		"items": ["Keris"],
		"targets": ["kalphite"],
		"name": "Keris",
		"description": "33% bonus damage against kalphites. 1/51 chance for 3x damage.",
	},
	"void_melee": {
		"items": ["Void melee helm", "Void knight top", "Void knight robe","Void knight gloves"],
		"name": "Void melee set",
		"description": "10% bonus to melee damage amd accuracy",
		"set": 4
	},
	"silverlight": {
		"items": ["Silverlight"],
		"targets": ["demon"],
		"name": "Silverlight",
		"description": "60% bonus to melee damage against demons"
	},
	"darklight": {
		"items": ["Darklight"],
		"targets": ["demon"],
		"name": "Darklight",
		"description": "60% bonus to melee damage against demons (unknown!)"
	},
	"arclight": {
		"items": ["Arclight"],
		"targets": ["demon"],
		"name": "Arclight",
		"description": "70% bonus to melee damage and accuracy against demons"
	}
}

# Item_name : special_name
# Generated from equipment_specials on startup
var items_with_specials : Dictionary



# Called when the node enters the scene tree for the first time.
func _ready():
	generate_items_with_specials()
	pass


func generate_items_with_specials():
	print( "Pregenrating specials")
	for effect in equipment_specials.keys():
		print( effect )
		for item_name in equipment_specials[effect]["items"]:
			if !item_name in items_with_specials:
				items_with_specials[item_name] = [effect]
			else:
				var temp : Array = items_with_specials[item_name]
				temp.append( effect )
				items_with_specials[item_name] = temp
	

func specials_of_item( item : equipment ) -> Array:
	
	if !items_with_specials.has( item.item_name ):
		return []
	
	return items_with_specials[ item.item_name ]

func item_is_blacklisted( item_name : String ) -> bool:
	# Items that are in the json but we don't want them
	
	# Manual blacklist list
	var blacklisted_items : Array = [
		"Amulet of glory (t1)",
		"Amulet of glory (t2)",
		"Amulet of glory (t3)",
		"Amulet of glory (t4)",
		"Amulet of glory (t5)",
		"Amulet of glory (t6)"
	]
	
	if item_name in blacklisted_items:
		return true
	
	# Charged jewelry
	var charges : Array = [
		"(1)",
		"(2)",
		"(3)",
		"(4)",
		"(5)",
		"(6)",
		"(7)",
		"(8)",
		"(9)",
	]
	for elem in charges:
		if elem in item_name:
			return true
	
	
	# Damaged barrows gear
	var barrow_names = ["Verac", "Ahrim", "Torag", "Guthan", "Karil", "Dharok"]
	var barrow_charges = ["25", "50", "75", "100"]
	for barrow in barrow_names:
		for charge in barrow_charges:
			if barrow in item_name and charge in item_name:
				return true
			
	return false
