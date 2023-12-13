import json

items = json.load(open('items-complete.json'))
monsters = json.load(open('monsters-complete.json'))

with open('items-complete.json', 'w') as outfile:
	json.dump(items, outfile, indent='\t')
with open('monsters-complete.json', 'w') as outfile:
	json.dump(monsters, outfile, indent='\t')