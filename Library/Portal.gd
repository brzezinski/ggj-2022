extends Area2D
signal player_hit

var enabled = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Portal_body_entered(body):
	print("_on_Portal_body_entered")
	if body.name == "Player" && enabled:
		enabled = false
		$Timer.start()
		print("emitting signal")
		emit_signal("player_hit")

func _on_Timer_timeout():
	enabled = true
