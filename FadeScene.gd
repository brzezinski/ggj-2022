extends ColorRect

signal transitioned

func _ready():
	transition()

func transition():
	$AnimationPlayer.play("fade")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade":
		emit_signal("transitioned")
	self.get_parent().remove_child(self)
