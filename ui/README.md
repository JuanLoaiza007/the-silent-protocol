# User Interface Scenes

This directory stores the primary GUI scene (gui.tscn, typically a Control node) and any related assets like custom fonts, styles, or specific UI scripts. Keeping the GUI separate from the World prevents it from being deleted during level transitions (if it is a sibling of the World node under Main).
