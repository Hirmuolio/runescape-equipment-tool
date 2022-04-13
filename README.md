# runescape-equipment-tool

Tool for simulating armor and weapon effectiveness against monsters.

The tool can currently handle only melee weapons.

# What it does

With this tool you can set your levels, equipment and target monster.
The tool then calculates your max hit, hit chance and damage per second (DPS).

For more accurate results press the "simulate" button. This simulation can take a while if you try to simulate with very slow kills (low levels, poor equipment or strong monster). This will calculate simulated DPS and time to kill.
These simulated results take into account that monster may have less hp than your max hit so the resulting DPS is lower than paper DPS.

![example](https://user-images.githubusercontent.com/22011552/163157956-8291a9d3-2b92-4864-bd01-e92d45efc513.png)


# Known inaccurate data:
* Monsters with multiple attack types only use the first one listed.
* Magic based melee/range is not handled.
* Melee accuracy equations are untested (not practical to test).
* Player magic defence equation is based on quessing.
* Using more than one item with damage/accuracy multiplier may be wrong with some items (needs testing).
* Darklight damage bonus is unknown.
* Snelm damage reduction is unknown.
* Probably various bugs.
* Loading bad setups will give bad results.
* You can do nonsense setups.

Monster/item data was sourced from https://www.osrsbox.com/projects/osrsbox-db/ (seems to be dead now).
