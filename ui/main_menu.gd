extends Control

@onready var play_button = $PlayButton

func _ready():
	AudioManager.change_music(AudioManager.TRACKS.LOOP_GUITAR)
	play_button.connect("pressed", Callable(self, "_on_play_pressed"))

func _on_play_pressed():
	get_node("/root/Main/GameWorld").start_game()
