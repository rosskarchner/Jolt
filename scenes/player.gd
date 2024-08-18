extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:


	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var lr_direction := Input.get_axis("ui_left", "ui_right")
	var ud_direction := Input.get_axis("ui_up", "ui_down")
	if lr_direction:
		velocity.x = lr_direction * SPEED
	else:
		velocity.x = 0
	if ud_direction:
		velocity.y = ud_direction * SPEED
	else:
		velocity.y = 0
	if not (lr_direction or ud_direction):
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
