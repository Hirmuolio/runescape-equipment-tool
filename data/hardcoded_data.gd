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
		"items": ["Keris", "Keris(p)", "Keris(p+)", "Keris(p++)", "Keris partisan"],
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
		"description": "2.5% magic damage bonus",
		"set": 4
	},
	"elite_void_ranged": {
		"items": ["Elite void robe", "Elite void top", "Void knight gloves", "Void ranger helm"],
		"name": "Elite void mage",
		"description": "2.5% ranged damage bonus",
		"set": 4
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
		"items": ["Opal bolts (e)", "Opal dragon bolts (e)"],
		"name": "Opal bolts (e)",
		"description": "5% chance to deal [ranged level]/10 damage"
	},
	"jade_bolt_e": {
		"items": ["Jade bolts (e)", "Jade dragon bolts (e)"],
		"name": "Jade bolts (e)",
		"description": "6% chance to deal bind target on place (not simulated)"
	},
	"pearl_bolt_e": {
		"items": ["Pearl bolts (e)", "Pearl dragon bolts (e)"],
		"name": "Pearl bolts (e)",
		"description": "6% chance to add [ranged level]/20 ( [ranged level]/15 against fiery targets) damage to hit"
	},
	"emerald_bolt_e": {
		"items": ["Emerald bolts (e)", "Emerald dragon bolts (e)"],
		"name": "Emerald bolts (e)",
		"description": "55% (54% in pvp) chance to poison target by 5 points (not implemented)"
	},
	"ruby_bolt_e": {
		"items": ["Ruby bolts (e)", "Ruby dragon bolts (e)"],
		"name": "Ruby bolts (e)",
		"description": "6% (11% in pvp) chance to deal 20% of target's remaining HP in damage (max 100 damage). Also reduces user's current HP by 10%. Does not activate if user would die."
	},
	"diamond_bolt_e": {
		"items": ["Diamond bolts (e)", "Diamond dragon bolts (e)"],
		"name": "Diamond bolts (e)",
		"description": "10% (5% in pvp) chance to quarantee a hit with 15% extra damage. Status changes are ignored for this hit."
	},
	"dragonstone_bolt_e": {
		"items": ["Dragonstone bolts (e)", "Dragonstone dragon bolts (e)"],
		"name": "Dragonstone bolts (e)",
		"description": "6% chance to apply [ranged level]/20 extra damage. Does not activate against targets immune to dragonfire."
	},
	"onyx_bolt_e": {
		"items": ["Onyx bolts (e)", "Onyx dragon bolts (e)"],
		"name": "Onyx bolts (e)",
		"description": "11% (10% in pvp) chance to deal 20% extra damage and heal the user by 25% of the damage dealt. Does not work against undead."
	},
	"scythe_vitur": {
		"items": ["Scythe of vitur"],
		"name": "Scythe of vitur",
		"description": "Hits large targets up to three times per attack. -50% damage on second hit and -75% damage on third hit."
	},
	"damned_ahrim": {
		"items": ["Amulet of the damned", "Ahrim's hood", "Ahrim's robetop", "Ahrim's robeskirt", "Ahrim's staff"],
		"name": "Amulet of the Damned + Ahrim set",
		"description": "25% chance to deal 30% more damage.",
		"set": 5
	},
	"damned_karil": {
		"items": ["Amulet of the damned", "Karil's coif", "Karil's leathertop", "Karil's leatherskirt", "Karil's crossbow"],
		"name": "Amulet of the Damned + Karil set",
		"description": "25% chance to hit twice. The second hit deals half damage.",
		"set": 5
	},
	"damned_dharok": {
		"items": ["Amulet of the damned", "Dharok's helm", "Dharok's platebody", "Dharok's platelegs", "Dharok's greataxe"],
		"name": "Amulet of the Damned + Dharok set",
		"description": "25% chance to recoil 15% of damage taken. (Not implemented)",
		"set": 5
	},
	"damned_torag": {
		"items": ["Amulet of the damned", "Torag's helm", "Torag's platebody", "Torag's platelegs", "Torag's hammers"],
		"name": "Amulet of the Damned + Torag set",
		"description": "+1% to defence level for every 1 Hitpoint missing. (Not implemented)",
		"set": 5
	},
	"ring_of_recoil": {
		"items": ["Ring of recoil", "Ring of suffering", "Ring of suffering (i)"],
		"name": "Ring of recoil",
		"description": "Recoild 10% + 1 of the received damage back. (Not implemented)"
	},
	"verac": {
		"items": ["Verac's helm", "Verac's brassard", "Verac's plateskirt", "Verac's flail"],
		"name": "Verac the Defiled",
		"description": "25% chance for quaranteed hit with +1 damage bonus.",
		"set": 4
	},
	"god_cape": {
		"items": ["Saradomin cape", "Zamorak cape", "Guthix cape",
		"Imbued saradomin cape", "Imbued zamorak cape", "Imbued guthix cape",
		"Imbued saradomin max cape", "Imbued zamorak max cape", "Imbued guthix max cape"],
		"name": "God cape",
		"description": ""
	},
	"powered_staff": {
		"items": ["Trident of the seas", "Trident of the seas (full)", "Trident of the seas (e)", 
		"Starter staff",
		"Trident of the swamp", "Trident of the swamp (e)",
		"Sanguinesti staff", "Holy sanguinesti staff",
		"Dawnbringer",
		"Crystal staff (basic)", "Crystal staff (attuned)", "Crystal staff (perfected)"],
		"name": "Powered staff",
		"description": ""
	},
	"bulwark": {
		"items": ["Dinh's bulwark"],
		"name": "Dinh's bulwark",
		"description": "Str bonus increases based on defence bonuses. 20% damage reduction in block mode."
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
		},
		"type": ["defence"]
	},
	"def_10": {
		"name": "Rock Skin",
		"description": "+10% Defence",
		"modifiers": {
			"defence": 10
		},
		"type": ["defence"]
	},
	"def_15": {
		"name": "Steel Skin",
		"description": "+15% Defence",
		"modifiers": {
			"defence": 15
		},
		"type": ["defence"]
	},
	"str_5": {
		"name": "Burst of Strength",
		"description": "+5% Strength",
		"modifiers": {
			"strength": 5
		},
		"type": ["damage"]
	},
	"str_10": {
		"name": "Superhuman Strength",
		"description": "+10% Strength",
		"modifiers": {
			"strength": 10
		},
		"type": ["damage"]
	},
	"str_15": {
		"name": "Ultimate Strength",
		"description": "+15% Strength",
		"modifiers": {
			"strength": 15
		},
		"type": ["damage"]
	},
	"att_5": {
		"name": "Clarity of Thought",
		"description": "+5% Attack",
		"modifiers": {
			"attack": 5
		},
		"type": ["accuracy"]
	},
	"att_10": {
		"name": "Improved Reflexes",
		"description": "+10% Attack",
		"modifiers": {
			"attack": 10
		},
		"type": ["accuracy"]
	},
	"att_15": {
		"name": "Incredible Reflexes",
		"description": "+15% Attack",
		"modifiers": {
			"attack": 15
		},
		"type": ["accuracy"]
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

func load_spells():
	
	var spells : Dictionary = {
		"wind_strike":{
			"name": "Wind strike",
			"damage": 2,
			"attributes": ["standard", "air", "strike"]
		},
		"water_strike":{
			"name": "Water strike",
			"damage": 4,
			"attributes": ["standard", "water", "strike"]
		},
		"earth_strike":{
			"name": "Earth strike",
			"damage": 6,
			"attributes": ["standard", "earth", "strike"]
		},
		"fire_strike":{
			"name": "Fire strike",
			"damage": 8,
			"attributes": ["standard", "fire", "strike"]
		},
		"wind_bolt":{
			"name": "Wind bolt",
			"damage": 9,
			"attributes": ["standard", "air", "bolt"]
		},
		"water_bolt":{
			"name": "Water bolt",
			"damage": 10,
			"attributes": ["standard", "water", "bolt"]
		},
		"earth_bolt":{
			"name": "Earth bolt",
			"damage": 11,
			"attributes": ["standard", "earth", "bolt"]
		},
		"fire_bolt":{
			"name": "Fire bolt",
			"damage": 12,
			"attributes": ["standard", "fire", "bolt"]
		},
		"crumble_undead":{
			"name": "Crumble undead",
			"damage": 15,
			"attributes": ["standard", "undead"]
		},
		"wind_blast":{
			"name": "Wind blast",
			"damage": 13,
			"attributes": ["standard", "air", "blast"]
		},
		"water_blast":{
			"name": "Water blast",
			"damage": 14,
			"attributes": ["standard", "water", "blast"]
		},
		"earth_blast":{
			"name": "Earth blast",
			"damage": 15,
			"attributes": ["standard", "earth", "blast"]
		},
		"fire_blast":{
			"name": "Fire blast",
			"damage": 16,
			"attributes": ["standard", "fire", "blast"]
		},
		"magic_dart":{
			"name": "Magic dart",
			"damage": 1,
			"attributes": ["standard", "blast"]
		},
		"saradomin_strike":{
			"name": "Saradomin strike",
			"damage": 20,
			"attributes": ["standard", "god_spell"]
		},
		"zamorak_flames":{
			"name": "Flames of Zamorak",
			"damage": 20,
			"attributes": ["standard", "god_spell"]
		},
		"guthix_claws":{
			"name": "Claws of Guthix",
			"damage": 20,
			"attributes": ["standard", "god_spell"]
		},
		"wind_wave":{
			"name": "Wind wave",
			"damage": 17,
			"attributes": ["standard", "wind", "wave"]
		},
		"water_wave":{
			"name": "Water wave",
			"damage": 18,
			"attributes": ["standard", "water", "wave"]
		},
		"earth_wave":{
			"name": "Earth wave",
			"damage": 19,
			"attributes": ["standard", "earth", "wave"]
		},
		"fire_wave":{
			"name": "Fire wave",
			"damage": 20,
			"attributes": ["standard", "fire", "wave"]
		},
		"iban_blast":{
			"name": "Iban blast",
			"damage": 25,
			"attributes": ["standard"]
		},
		"wind_surge":{
			"name": "Wind surge",
			"damage": 21,
			"attributes": ["standard", "wind", "surge"]
		},
		"water_surge":{
			"name": "Water surge",
			"damage": 22,
			"attributes": ["standard", "water", "surge"]
		},
		"earth_surge":{
			"name": "Earth surge",
			"damage": 23,
			"attributes": ["standard", "earth", "surge"]
		},
		"fire_surge":{
			"name": "Fire surge",
			"damage": 24,
			"attributes": ["standard", "fire", "surge"]
		},
		"smoke_rush":{
			"name": "Smoke rush",
			"damage": 13,
			"attributes": ["ancient", "smoke", "rush"]
		},
		"shadow_rush":{
			"name": "Shadow rush",
			"damage": 14,
			"attributes": ["ancient", "shadow", "rush"]
		},
		"blood_rush":{
			"name": "Blood rush",
			"damage": 15,
			"attributes": ["ancient", "blood", "rush"]
		},
		"ice_rush":{
			"name": "Ice rush",
			"damage": 16,
			"attributes": ["ancient", "ice", "rush"]
		},
		"smoke_burst":{
			"name": "Smoke burst",
			"damage": 17,
			"attributes": ["ancient", "smoke", "burst"]
		},
		"shadow_burst":{
			"name": "Shadow burst",
			"damage": 18,
			"attributes": ["ancient", "shadow", "burst"]
		},
		"blood_burst":{
			"name": "Blood burst",
			"damage": 21,
			"attributes": ["ancient", "blood", "burst"]
		},
		"ice_burst":{
			"name": "Ice burst",
			"damage": 22,
			"attributes": ["ancient", "ice", "burst"]
		},
		"smoke_blitz":{
			"name": "Smoke blitz",
			"damage": 23,
			"attributes": ["ancient", "smoke", "blitz"]
		},
		"shadow_blitz":{
			"name": "Shadow blitz",
			"damage": 24,
			"attributes": ["ancient", "shadow", "blitz"]
		},
		"blood_blitz":{
			"name": "Blood blitz",
			"damage": 25,
			"attributes": ["ancient", "blood", "blitz"]
		},
		"ice_blitz":{
			"name": "Ice blitz",
			"damage": 26,
			"attributes": ["ancient", "ice", "blitz"]
		},
		"smoke_barrage":{
			"name": "Smoke barrage",
			"damage": 27,
			"attributes": ["ancient", "smoke", "barrage"]
		},
		"shadow_barrage":{
			"name": "Shadow barrage",
			"damage": 28,
			"attributes": ["ancient", "shadow", "barrage"]
		},
		"blood_barrage":{
			"name": "Blood barrage",
			"damage": 29,
			"attributes": ["ancient", "blood", "barrage"]
		},
		"ice_barrage":{
			"name": "Ice barrage",
			"damage": 30,
			"attributes": ["ancient", "ice", "barrage"]
		},
		"demonbane_1":{
			"name": "Inferior demonbane",
			"damage": 16,
			"attributes": ["arceeus", "demonbane"]
		},
		"demonbane_2":{
			"name": "Superior demonbane",
			"damage": 23,
			"attributes": ["arceeus", "demonbane"]
		},
		"demonbane_3":{
			"name": "Dark demonbane",
			"damage": 30,
			"attributes": ["arceeus", "demonbane"]
		}
	}
	
	#"wind_strike":{
	#	"name": "Wind strike",
	#	"damage": 2,
	#	"attributes": ["standard", "air", "strike"]
	#}
	
	var class_item = load( "res://data/equipment.tscn" )
	var id : int = -1
	for spell in spells.values():
		var new_item : equipment = class_item.instance()
		Database.get_node("items").add_child( new_item )
		
		new_item.item_name = spell["name"]
		new_item.magic_max_hit = spell["damage"]
		new_item.special_effects = spell["attributes"]
		
		new_item.equipment_slot = "spell"
		new_item.item_id = id
		new_item.set_name( String( new_item.item_id ) )
		id -= 1
	pass

