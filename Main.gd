extends Node

const MUSIC_DEFAULT = preload("res://Library/Sfx/Music/bounce_ggj01.wav")
const MUSIC_EARTH = MUSIC_DEFAULT
const MUSIC_SKY = preload("res://Library/Sfx/Music/bounce_ggj02.wav")

var fade_scene

var PreviousScene
var player_position

# Called when the node enters the scene tree for the first time.
func _ready():
	$MusicPlayer.stream = MUSIC_DEFAULT
	$MusicPlayer.play()
	$MusicPlayer.connect("finished", self, "play_music")
	var player_root = get_tree().get_root().get_node("Main/Earth/Environment/Player")
	var new_player = load("res://Library/Player/Player.tscn").instance()
	new_player.add_to_group("player", true)
	new_player.position = $StartPosition.position
	player_root.add_child(new_player)
	if !fade_scene:
		fade_scene = preload("res://FadeScene.tscn").instance()

func play_music():
	#if (!$MusicPlayer.is_playing()):
		$MusicPlayer.play()
		
func play_music_new(new_music):
	if (!new_music):
		$MusicPlayer.stream = new_music
	play_music()
	
func _process(delta):
	#play_music()
	pass
	
func find_player():
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		return player

func _on_Portal_player_hit():
	print("_on_Portal_player_hit")
	switch_floor(find_player())

func reparent(child: Node, new_parent: Node):
	var new_player = child.duplicate(DUPLICATE_USE_INSTANCING)
	new_player.add_to_group("player", true)
	new_player.position = player_position
	new_parent.add_child(new_player)
	new_parent.get_node("Player").position = player_position
	child.queue_free()
	
func switch_floor(player):
	player_position = player.position
	print("old player position")
	print(player_position)
	var new_parent = player.get_parent().get_parent().get_parent()
	print("current player parent:")
	print(new_parent.get_name())
	if new_parent.get_name() == "Earth":
		fade_scene.rect_position = find_player().position
		#add_child(fade_scene)
		play_music_new(MUSIC_SKY)
		new_parent.queue_free()
		var new_scene = load("res://Sky.tscn").instance()
		new_scene.connect("collision",self,"_on_Portal_player_hit")
		add_child(new_scene)
		new_parent = get_tree().get_root().get_node("Main/Sky/Environment/Player")
	elif new_parent.get_name() == "Sky":
		fade_scene.rect_position = find_player().position
		#add_child(fade_scene)
		play_music_new(MUSIC_EARTH)
		new_parent.queue_free()
		var new_scene = load("res://Earth.tscn").instance()
		new_scene.connect("collision",self,"_on_Portal_player_hit")
		add_child(new_scene)
		new_parent = get_tree().get_root().get_node("Main/Earth/Environment/Player")
	else:
		return
	print("new player parent:")
	print(new_parent.get_parent().get_parent().get_name())	
	reparent(player, new_parent)

