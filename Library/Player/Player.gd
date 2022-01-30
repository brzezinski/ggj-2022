extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2.ZERO

var SPEED = 100
var velocity = Vector2()

const STATE_WALKING = 1
const STATE_FLYING = 2
const STATE_UP = 3
const STATE_DOWN = 4

var state = STATE_WALKING

#converting movement for izometric
func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x * 2 - cartesian.y, cartesian.x + cartesian.y / 2)
	
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
	
	if velocity.length() > 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	#reset sprite after flying
	if $AnimatedSprite.animation == "up" || $AnimatedSprite.animation == "down":
		$AnimatedSprite.animation = "idle"
		
	var which_level = check_level()	
		
	if velocity.x > 0:
		if which_level == "Earth":
			$AnimatedSprite.animation = "walk"
		else: 
			$AnimatedSprite.animation = "fly"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = true
	if velocity.x < 0:
		if which_level == "Earth":
			$AnimatedSprite.animation = "back"
		else:
			$AnimatedSprite.animation = "fly-b"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = false
	elif velocity.y > 0:
		if which_level == "Earth":
			$AnimatedSprite.animation = "walk"
		else:
			$AnimatedSprite.animation = "fly"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = false
	elif velocity.y < 0:
		if which_level == "Earth":
			$AnimatedSprite.animation = "back"
		else:
			$AnimatedSprite.animation = "fly-b"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = true
	
func _physics_process(delta):
	#if chaning level move character automaticaly
	match state:
		STATE_UP: 
			velocity = move_and_collide(Vector2(0,-1)*SPEED*delta)
			$AnimatedSprite.animation = "up"
			return
		STATE_DOWN:
			velocity = move_and_collide(Vector2(0,1)*SPEED*delta)
			$AnimatedSprite.animation = "down"
			return 
	get_input()
	velocity = move_and_collide(cartesian_to_isometric(velocity * delta))
	for i in get_slide_count():
		var collision = get_slide_collision(i)

#where we are?
func check_level():
	var check_parent = self.get_parent().get_parent().get_parent()
	return check_parent.get_name()
	
func fly_up():
	state = STATE_UP

func fly_down():
	state = STATE_DOWN
	
func walking():
	state = STATE_WALKING
	
func flying():
	state = STATE_FLYING
