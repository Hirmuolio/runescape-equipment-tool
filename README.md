# runescape-equipment-tool

Tool for simulating armor and weapon effectiveness against monsters.

Web version is currently not available since I don't know hot to configure it for godot4.

# What it does

With this tool you can set your levels, equipment and target monster.
The tool then calculates your max hit, hit chance and damage per second (DPS).

For more accurate results press the "simulate" button. This simulation can take a while if you try to simulate with very slow kills (low levels, poor equipment or strong monster). This will calculate simulated DPS and time to kill.
These simulated results take into account that monster may have less hp than your max hit so the resulting DPS is lower than paper DPS.

![example](https://user-images.githubusercontent.com/22011552/163157956-8291a9d3-2b92-4864-bd01-e92d45efc513.png)


# Known inaccurate data:
* Monsters with multiple attack types only use the first one listed.
* Accuracy equations are untested (not practical to test).
* Various things are unknown (or the wiki gives conflictin data).
* Probably various bugs.
* Loading bad setups will give bad results.
* You can do nonsense setups.

Monster/item data was sourced from https://github.com/0xNeffarion/osrsreboxed-db/tree/master
