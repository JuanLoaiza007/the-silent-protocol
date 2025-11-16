# World Management Scene

This directory contains the base scene for the in-game environment, typically named game_world.tscn. This scene acts as the parent node (Node3D) responsible for managing level transitions (swapping level_1.tscn and level_2.tscn as children) and mediating communications between siblings (e.g., Player and Villain, if they are siblings of World).
