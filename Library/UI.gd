extends Control

var cat_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func cat_catched():
	cat_counter += 1
	$CatCounter.text = "%s" % cat_counter
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
