extends Node

const MUSIC_DEFAULT = preload("res://Library/Sfx/Music/bounce_ggj01.wav")
const MUSIC_EARTH = MUSIC_DEFAULT
const MUSIC_SKY = preload("res://Library/Sfx/Music/bounce_ggj02.wav")
const AMBIENT_EARTH = preload("res://Library/Sfx/Environment/Birds.wav")
const AMBIENT_SKY = preload("res://Library/Sfx/Environment/Clouds.wav")

var fade_scene

var PreviousScene
var player_position

# Called when the node enters the scene tree for the first time.
func _ready():
	$MusicPlayer.stream = MUSIC_DEFAULT
	$MusicPlayer.play()
	$MusicPlayer.connect("finished", self, "play_music")
	prepare_player()
	#TODO
	if !fade_scene:
		fade_scene = preload("res://FadeScene.tscn").instance()

#prepare player for the level
func prepare_player():
	var player_root = get_tree().get_root().get_node("Main/Earth/Environment/Player")
	var new_player = load("res://Library/Player/Player.tscn").instance()
	new_player.add_to_group("player", true)
	new_player.position = $StartPosition.position
	player_root.add_child(new_player)
	
func play_music():
	#if (!$MusicPlayer.is_playing()):
		$MusicPlayer.play()
		
func play_music_new(new_music):
	if (!new_music):
		$MusicPlayer.stream = new_music
	play_music()
	
#func _process(delta):
	#play_music()
#	pass
	
#on which level player is right now?
func find_player():
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		return player

#player enter the portal
func _on_Portal_player_hit():
	print("_on_Portal_player_hit")
	var my_player = find_player()
	if my_player.get_parent().get_parent().get_parent().get_name() == "Earth":
		my_player.fly_up()
	else:
		my_player.fly_down()
	#start warp timer to finish flying
	$WarpTimer.start()

#change player parent to the new level
func reparent(child: Node, new_parent: Node):
	var new_player = child.duplicate(DUPLICATE_USE_INSTANCING)
	new_player.add_to_group("player", true)
	new_player.position = player_position
	new_parent.add_child(new_player)
	new_parent.get_node("Player").position = player_position
	child.queue_free()
	
#change level
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
		$AmbientPlayer.stream = AMBIENT_SKY
		new_parent.queue_free()
		var new_scene = load("res://Sky.tscn").instance()
		new_scene.connect("collision",self,"_on_Portal_player_hit")
		add_child(new_scene)
		new_parent = get_tree().get_root().get_node("Main/Sky/Environment/Player")
	elif new_parent.get_name() == "Sky":
		fade_scene.rect_position = find_player().position
		#add_child(fade_scene)
		play_music_new(MUSIC_EARTH)
		$AmbientPlayer.stream = AMBIENT_EARTH
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

#when player will hit new level
func _on_WarpTimer_timeout():
	$WarpTimer.stop()
	var my_player = find_player()
	switch_floor(my_player)
	my_player = find_player()
	if my_player.get_parent().get_parent().get_parent().get_name() == "Earth":
		my_player.walking()
	else:
		my_player.flying()
