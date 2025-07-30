extends CharacterBody2D

@export var SPEED : float = 300.0
@export var JUMP_VELOCITY : float = -400.0
@export var pushForce : float = 80.0


func _physics_process(delta: float) -> void:
	if $RecordingManager.isReverting:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	for i in get_slide_collision_count():
		var coll = get_slide_collision(i)
		if coll.get_collider() is RigidBody2D:
			(coll.get_collider() as RigidBody2D).apply_central_impulse(-coll.get_normal() * pushForce)

	move_and_slide()
