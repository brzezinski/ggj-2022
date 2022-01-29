extends Node

const MUSIC_DEFAULT = null #= preload("res://Sounds/....")

var PreviousScene

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


func _on_Portal_player_hit():
	print("_on_Portal_player_hit")
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		switch_floor(player)
		break

func reparent(child: Node, new_parent: Node):
	var new_player = child.duplicate(DUPLICATE_USE_INSTANCING)
	new_player.add_to_group("player", true)
	new_parent.add_child(new_player)
	child.queue_free()
		
		
func hide_landscape(selected_node):
	PreviousScene = selected_node
	selected_node.visible = false
	remove_child(selected_node)

func show_landscape(selected_node):
	if PreviousScene:
		add_child(PreviousScene)
	selected_node.visible = true
	
	
func swap_scenes(old_scene):
	if PreviousScene:
		add_child(PreviousScene)
		PreviousScene.visible = true
	PreviousScene = old_scene
	old_scene.visible = false
	remove_child(old_scene)
	
func switch_floor(player):
	var new_parent = player.get_parent().get_parent().get_parent()
	print("current player parent:")
	print(new_parent.get_name())
	if new_parent.get_name() == "Earth":
		swap_scenes(new_parent)
		new_parent = get_tree().get_root().get_node("Main/Sky/Environment/Player")
	elif new_parent.get_name() == "Sky":
		swap_scenes(new_parent)
		get_tree().get_root().get_node("Main/Earth").visible = true
		new_parent = get_tree().get_root().get_node("Main/Earth/Environment/Player")
		
	else:
		return
	print("new player parent:")
	print(new_parent.get_parent().get_parent().get_name())	
	reparent(player, new_parent)

