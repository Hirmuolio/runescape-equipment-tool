extends Node


# Tells what items have specific special attribute
var equipment_specials : Dictionary = {
	"black_mask" : {
		"items": ["Black mask", "Black mask (i)", "Slayer helmet", "Slayer helmet (i)"],
		"name": "Black mask/slayer helm",
		"description": "16.67% bonus to melee accuracy and damage against slayer target."
	},
	"black_mask_i" : {
		"items": ["Black mask (i)", "Slayer helmet (i)"],
		"name": "Black mask/slayer helm (i)",
		"description": "15% bonus to ranged accuracy, ranged damage, magic accuracy and magic damage."
	},
	"salve": {
		"items": ["Salve amulet", "Salve amulet(i)"],
		"name": "Salve amulet",
		"description": "16.67% melee damage and accuracy bonus against undead. Does not stack with black mask/slayer helmet."
	},
	"salve_e": {
		"items": ["Salve amulet (e)", "Salve amulet(ei)"],
		"name": "Salve amulet (e)",
		"description": "20% melee damage and accuracy bonus against undead. Does not stack with black mask/slayer helmet."
	},
	"salve_ei": {
		"items": ["Salve amulet(ei)"],
		"name": "Salve amulet (ei)",
		"description": "20% magic and ranged damage and accuracy bonus against undead. Does not stack with black mask/slayer helmet."
	},
	"salve_i": {
		"items": ["Salve amulet(i)"],
		"name": "Salve amulet (i)",
		"description": "16.67% ranged damage and accuracy bonus against undead. 15% magic damage and accuracy bonus against undead. Does not stack with black mask/slayer helmet."
	},
	"ivandis_flail": {
		"items": ["Ivandis flail"],
		"name": "Ivandis flail",
		"description": "20% damage bonus against vampyres."
	},
	"blisterwood_flail": {
		"items": ["Blisterwood flail"],
		"name": "Blisterwood flail",
		"description": "25% damage and 5% accuracy bonus against vampyres."
	},
	"blisterwood_sickle": {
		"items": ["Blisterwood sickle"],
		"name": "Blisterwood sickle",
		"description": "15% damage and 5% accuracy bonus against vampyres."
	},
	"avarice": {
		"items": ["Amulet of avarice"],
		"name": "Amulet of avarice",
		"description": "20% damage and accuracy against revenants. (not implemented)"
	},
	"ethereum": {
		"items": ["Bracelet of ethereum"],
		"name": "Bracelet of ethereum",
		"description": "75% reduced damage from revenants (not implemented)"
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
		"name": "Viggora's chainmace",
		"description": "50% bonus to melee damage amd accuracy in wilderness (only in PvE)",
	},
	"craw": {
		"items": ["Craw's bow"],
		"name": "Craw's bow",
		"description": "50% bonus to ranged damage amd accuracy in wilderness (only in PvE)",
	},
	"inquisitor_1": {
		"items": ["Inquisitor's hauberk", "Inquisitor's plateskirt", "Inquisitor's great helm"],
		"set": 1,
		"name": "Inquisitor's armour - 1 piece",
		"description": "0.5% bonus to crush damage and accuracy",
	},
	"inquisitor_2": {
		"items": ["Inquisitor's hauberk", "Inquisitor's plateskirt", "Inquisitor's great helm"],
		"set": 2,
		"removes": ["inquisitor_1"],
		"name": "Inquisitor's armour - 2 pieces",
		"description": "1% bonus to crush damage and accuracy",
	},
	"inquisitor_3": {
		"items": ["Inquisitor's hauberk", "Inquisitor's plateskirt", "Inquisitor's great helm"],
		"set": 3,
		"removes": ["inquisitor_1", "inquisitor_2"],
		"name": "Inquisitor's armour - 3 pieces",
		"description": "2.5% bonus to crush damage and accuracy",
	},
	"keris": {
		"items": ["Keris", "Keris(p)", "Keris(p+)", "Keris(p++)"],
		"name": "Keris",
		"description": "33% bonus damage against kalphites. 1/51 chance for 3x damage.",
	},
	"gadderhammer": {
		"items": ["Gadderhammer"],
		"name": "Gadderhammer",
		"description": "25% bonus damage against shades. 1/20 chance for 2x damage.",
	},
	"void_melee": {
		"items": ["Void melee helm", "Void knight top", "Elite void top", "Void knight robe", "Elite void robe", "Void knight gloves"],
		"name": "Void melee set",
		"description": "10% bonus to melee damage and accuracy",
		"set": 4
	},
	"void_ranged": {
		"items": ["Void ranger helm", "Void knight top", "Elite void top", "Void knight robe", "Elite void robe", "Void knight gloves"],
		"name": "Void ranger set",
		"description": "10% bonus to ranged damage and accuracy",
		"set": 4
	},
	"void_magic": {
		"items": ["Void mage helm", "Void knight top", "Elite void top", "Void knight robe", "Elite void robe", "Void knight gloves"],
		"name": "Void ranger set",
		"description": "45% bonus to magic accuracy",
		"set": 4
	},
	"elite_void_magic": {
		"items": ["Elite void robe", "Elite void top", "Void knight gloves", "Void mage helm"],
		"name": "Elite void mage",
		"description": "2.5% magic damage bonus"
	},
	"elite_void_ranged": {
		"items": ["Elite void robe", "Elite void top", "Void knight gloves", "Void ranger helm"],
		"name": "Elite void mage",
		"description": "2.5% ranged damage bonus"
	},
	"silverlight": {
		"items": ["Silverlight"],
		"name": "Silverlight",
		"description": "60% bonus to melee damage against demons"
	},
	"darklight": {
		"items": ["Darklight"],
		"name": "Darklight",
		"description": "60% bonus to melee damage against demons (unkown)"
	},
	"arclight": {
		"items": ["Arclight"],
		"name": "Arclight",
		"description": "70% bonus to melee damage and accuracy against demons"
	},
	"snelm": {
		"items": ["Blood'n'tar snelm", "Broken bark snelm", "Bruise blue snelm", "Myre snelm", "Ochre snelm"],
		"name": "Snelm",
		"description": "Reduces damage taken from snails (unknown)"
	},
	"dragonhunter_lance": {
		"items": ["Dragon hunter lance"],
		"name": "Dragon hunter lance",
		"description": "20% damage and accuracy bonus against dragons"
	},
	"dragonhunter_crossbow": {
		"items": ["Dragon hunter crossbow"],
		"name": "Dragon hunter crossbow",
		"description": "25% damage and 30% accuracy bonus against dragons"
	},
	"leaf_baxe": {
		"items": ["Leaf-bladed battleaxe"],
		"name": "Leaf-bladed battleaxe",
		"description": "17.5% damage and accuracy bonus against turoths and kurasks"
	},
	"barronite": {
		"items": ["Barronite mace"],
		"name": "Barronite mace",
		"description": "15% damage bonus against golems"
	},
	"holy_water": {
		"items": ["Holy water"],
		"name": "Holy water",
		"description": "Unknown bonus against demons"
	},
	"twisted": {
		"items": ["Twisted bow"],
		"name": "Twisted bow",
		"description": "Increased damage and accuracy basaed on enemy magic level/accuracy"
	},
	"slayer_staff_e": {
		"items": ["Slayer's staff (e)"],
		"name": "Slayer's staff (e)",
		"description": "Increased slayer dart damage against slayer tasks"
	},
	"chaos_gauntlet": {
		"items": ["Chaos gauntlets"],
		"name": "Chaos gauntlets",
		"description": "+3 to bolt spell damage"
	},
	"tome_of_fire": {
		"items": ["Tome of fire"],
		"name": "Tome of fire",
		"description": "+50% bonus for fire spell damage"
	},
	"tome_of_water": {
		"items": ["Tome of water"],
		"name": "Tome of water",
		"description": "+20% bonus for water spell damage and accuracy"
	},
	"somke_bass": {
		"items": ["Smoke battlestaff"],
		"name": "Smoke battlestaff",
		"description": "+10% bonus for standard spell damage and accuracy"
	},
	"thammaron": {
		"items": ["Thammaron's sceptre"],
		"name": "Thammaron's sceptre",
		"description": "+100% accuracy and +25% damage to magic (NPC only in wilderness)"
	},
	"opal_bolt_e": {
		"items": ["Opal bolts (e)"],
		"name": "Opal bolts (e)",
		"description": "5% chance to deal [ranged level]/10 damage"
	},
	"jade_bolt_e": {
		"items": ["Jade bolts (e)"],
		"name": "Jade bolts (e)",
		"description": "6% chance to deal bind target on place"
	},
	"pearl_bolt_e": {
		"items": ["Pearl bolts (e)"],
		"name": "Pearl bolts (e)",
		"description": "6% chance to add [ranged level]/20 ( [ranged level]/15 against fiery targets) damage to hit"
	},
	"emerald_bolt_e": {
		"items": ["Emerald bolts (e)"],
		"name": "Emerald bolts (e)",
		"description": "55% (54% in pvp) chance to poison target by 5 points (not implemented)"
	},
	"ruby_bolt_e": {
		"items": ["Ruby bolts (e)"],
		"name": "Ruby bolts (e)",
		"description": "6% (11% in pvp) chance to deal 20% of target's remaining HP in damage (max 100 damage). Also reduces user's current HP by 10%. Does not activate if user would die."
	},
	"diamond_bolt_e": {
		"items": ["Diamond bolts (e)"],
		"name": "Diamond bolts (e)",
		"description": "10% (5% in pvp) chance to quarantee a hit with 15% extra damage. Status changes are ignored for this hit."
	},
	"dragonstone_bolt_e": {
		"items": ["Dragonstone bolts (e)"],
		"name": "Dragonstone bolts (e)",
		"description": "6% chance to apply [ranged level]/20 extra damage. Does not activate against targets immune to dragonfire."
	},
	"onyx_bolt_e": {
		"items": ["Onyx bolts (e)"],
		"name": "Onyx bolts (e)",
		"description": "11% (10% in pvp) chance to deal 20% extra damage and heal the user by 25% of the damage dealt. Does not work against undead."
	}
}

# Item_name : special_name
# Generated from equipment_specials on startup
var items_with_specials : Dictionary


var prayers : Dictionary = {
	"def_5": {
		"name": "Thick Skin",
		"description": "+5% Defence",
		"modifiers": {
			"defence": 5
		}
	},
	"def_10": {
		"name": "Rock Skin",
		"description": "+10% Defence",
		"modifiers": {
			"defence": 10
		}
	},
	"def_15": {
		"name": "Steek Skin",
		"description": "+15% Defence",
		"modifiers": {
			"defence": 15
		}
	},
	"str_5": {
		"name": "Burst of Strength",
		"description": "+5% Strength",
		"modifiers": {
			"strength": 5
		}
	},
	"str_10": {
		"name": "Superhuman Strength",
		"description": "+10% Strength",
		"modifiers": {
			"strength": 10
		}
	},
	"str_15": {
		"name": "Ultimate Strength",
		"description": "+15% Strength",
		"modifiers": {
			"strength": 15
		}
	},
	"att_5": {
		"name": "Clarity of Thought",
		"description": "+5% Attack",
		"modifiers": {
			"attack": 5
		}
	},
	"att_10": {
		"name": "Improved Reflexes",
		"description": "+10% Attack",
		"modifiers": {
			"attack": 10
		}
	},
	"att_15": {
		"name": "Incredible Reflexes",
		"description": "+15% Attack",
		"modifiers": {
			"attack": 15
		}
	},
	"rng_5": {
		"name": "Sharp Eye",
		"description": "+5% Ranged",
		"modifiers": {
			"ranged": 5
		}
	},
	"rng_10": {
		"name": "Hawk Eye",
		"description": "+10% Ranged",
		"modifiers": {
			"ranged": 10
		}
	},
	"rng_15": {
		"name": "Eagle Eye",
		"description": "+15% Ranged",
		"modifiers": {
			"ranged": 15
		}
	},
	"rng_20": {
		"name": "Rigour",
		"description": "+20% Ranged attack, +23% Ranged strength, +25% Defence",
		"modifiers": {
			"ranged_attack": 20,
			"ranged_str": 23,
			"defence": 25
		}
	},
	"mage_5": {
		"name": "Mystic Will",
		"description": "+5% Magical attack and defence",
		"modifiers": {
			"magic": 5
		}
	},
	"mage_10": {
		"name": "Mystic Lore",
		"description": "+10% Magical attack and defence",
		"modifiers": {
			"magic": 10
		}
	},
	"mage_15": {
		"name": "Mystic Might",
		"description": "+15% Magical attack and defence",
		"modifiers": {
			"magic": 15
		}
	},
	"mage_25": {
		"name": "Augury",
		"description": "+25% Magical attack and defence, +25% Defence",
		"modifiers": {
			"magic_attack": 25,
			"magic_defence": 25,
			"defence": 25
		}
	},
	"chivalry": {
		"name": "Chivalry",
		"description": "+15% Attack, +18% Strength, +20% Defence",
		"modifiers": {
			"attack": 15,
			"strength": 18,
			"defence": 20
		}
	},
	"piety": {
		"name": "Piety",
		"description": "+20% Attack, +23% Strength, +25% Defence",
		"modifiers": {
			"attack": 20,
			"strength": 23,
			"defence": 25
		}
	}
}


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
	
	# Manualy whitelisted items
	var whitelisted_items : Array = [
		"Void seal(8)"
	]
	
	if item_name in whitelisted_items:
		return false
	
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
	
	# Locked items
	if "(l)" in item_name:
		return true
	
	# Damaged barrows gear
	var barrow_names = ["Verac", "Ahrim", "Torag", "Guthan", "Karil", "Dharok"]
	var barrow_charges = ["25", "50", "75", "100"]
	for barrow in barrow_names:
		for charge in barrow_charges:
			if barrow in item_name and charge in item_name:
				return true
			
	return false
