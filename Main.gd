extends Node

const MUSIC_DEFAULT = null #= preload("res://Sounds/....")

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
	player_root.add_child(new_player)

func play_music():
	if (!$MusicPlayer.is_playing()):
		$MusicPlayer.play()
		
func play_music_new(new_music):
	if (!new_music):
		$MusicPlayer.stream = new_music
	play_music()
	
func _process(delta):
	play_music()

func _on_Portal_player_hit():
	print("_on_Portal_player_hit")
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		switch_floor(player)
		break

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
		new_parent.queue_free()
		var new_scene = load("res://Sky.tscn").instance()
		new_scene.connect("collision",self,"_on_Portal_player_hit")
		add_child(new_scene)
		new_parent = get_tree().get_root().get_node("Main/Sky/Environment/Player")
	elif new_parent.get_name() == "Sky":
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

