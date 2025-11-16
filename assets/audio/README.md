# Audio Files

This subfolder contains all necessary audio assets, including music files (.ogg, .mp3) and sound effects (sfx) (.wav, .ogg). Audio files should be used with AudioStreamPlayer nodes. Ensure proper naming conventions for clarity, and consider creating a pooled system for frequently played sound effects (like coin pickups) to avoid clipping, though for small games, managing AudioStreamPlayer instances per scene might suffice.
