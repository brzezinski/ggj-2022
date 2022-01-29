extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2.ZERO

var SPEED = 100
var velocity = Vector2()

func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x *2 - cartesian.y, cartesian.x + cartesian.y / 2)
	
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
	velocity = move_and_collide(cartesian_to_isometric(velocity * delta))
	for i in get_slide_count():
		var collision = get_slide_collision(i)


