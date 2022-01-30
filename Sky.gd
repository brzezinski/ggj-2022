extends Node2D

signal collision

func _ready():
	pass # Replace with function body.

func _on_Portal_player_hit():
	emit_signal("collision")
