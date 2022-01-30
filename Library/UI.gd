extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func cat_catched():
	var cat_counter = get_tree().current_scene.cat_catched()
	$CatCounter.text = "%s" % cat_counter
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
