extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var SPEED = 25000
var velocity = Vector2()

func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, cartesian.x + cartesian.y / 2)
	
func get_input():
	# Detect up/down/left/right keystate and only move when pressed.
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	velocity = velocity.normalized() * SPEED
	
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(cartesian_to_isometric(velocity * delta))
	for i in get_slide_count():
		var collision = get_slide_collision(i)

#tests needed
func switch_floor():
	var new_parent = get_parent().get_parent().get_parent()
	print("current player parent:")
	print(new_parent.get_node().get_name())
	if new_parent.get_node().get_name() == "Earth":
		new_parent = new_parent.get_node("Sky/Environment")
	else:
		new_parent = new_parent.get_node("Earth/Environment")
	get_parent().remove_child(self)
	new_parent.add_child(self)
