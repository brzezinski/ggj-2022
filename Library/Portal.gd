extends Area2D
signal player_hit

var enabled = true

func _ready():
	pass


func _on_Portal_body_entered(body):
	print("_on_Portal_body_entered")
	if body.name == "Player" && enabled:
		#disable portal for timer time
		enabled = false
		$Timer.start()
		print("emitting signal")
		emit_signal("player_hit")

func _on_Timer_timeout():
	#reenable the portal (there where some multiple collisions issue)
	enabled = true
