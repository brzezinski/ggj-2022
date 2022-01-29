extends Node

const MUSIC_DEFAULT = null #= preload("res://Sounds/....")

# Called when the node enters the scene tree for the first time.
func _ready():
	$MusicPlayer.stream = MUSIC_DEFAULT
	$MusicPlayer.play()
	$MusicPlayer.connect("finished", self, "play_music")

func play_music():
	if (!$MusicPlayer.is_playing()):
		$MusicPlayer.play()
		
func play_music_new(new_music):
	if (!new_music):
		$MusicPlayer.stream = new_music
	play_music()
	
func _process(delta):
	play_music()
