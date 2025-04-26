extends CharacterBody2D

@export var speed: float = 200.0
@export var gravity: float = 600.0
@export var jump_strength: float = 400.0  # How high the character jumps
@export var kick_duration: float = 0.5  # Time duration of the kick
var is_kicking: bool = false

func _physics_process(delta):
	var input_direction = 0

	# Gravity (always applied)
	velocity.y += gravity * delta

	# Handle movement left/right
	if Input.is_action_pressed("move-left"):
		input_direction -= 1
	if Input.is_action_pressed("move-right"):
		input_direction += 1

	# Handle jump (only if the character is on the ground)
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = -jump_strength  # Apply an upward velocity

	# Horizontal movement
	velocity.x = input_direction * speed

	if is_kicking:
		velocity.x = 0  # No horizontal movement while kicking
		move_and_slide()
		return

	# Handle animations
	if Input.is_action_just_pressed("kick") and not is_kicking:
		kick()

	elif input_direction != 0:
		$AnimatedSprite2D.play("move")
		$AnimatedSprite2D.flip_h = input_direction < 0
	else:
		$AnimatedSprite2D.play("idle")

	move_and_slide()

func kick():
	is_kicking = true
	$AnimatedSprite2D.play("kick")
	await get_tree().create_timer(kick_duration).timeout
	is_kicking = false
	$AnimatedSprite2D.play("idle")
