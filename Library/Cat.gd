extends Area2D

const CAT_SFX = preload("res://Library/Sfx/Actions/cat_pickup.wav")

func _ready():
	$Meau.play()
	$Meau.connect("finished", self, "play_again")

#playing music in the loop
func play_again():
	$Meau.play()

func _on_Cat_body_entered(body):
	if body.name == "Player":
		cat_pickup()

#when player will hit the cat
func cat_pickup():
	$CollisionPolygon2D.queue_free()
	$AnimatedSprite.animation = "pickup"
	$Meau.stream = CAT_SFX
	$Meau.play()
	$Timer.start()
	var uis = get_tree().get_nodes_in_group("UI")
	for ui in uis:
		ui.cat_catched()
		return

#remove the cat from the scene
func _on_Timer_timeout():
	queue_free()
