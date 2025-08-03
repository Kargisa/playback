extends CharacterBody2D
class_name Player

class_name PlayerMovement

@export var SPEED : float = 80.0
@export var SPEED_MULT_WHILE_CHARGING : float = 0.5
@export var SPEED_MULT_WHILE_IN_AIR : float = 1.2
@export var BASE_JUMP_VELOCITY : float = -100.0
@export var MAX_JUMP_VELOCITY: float = -350.0
@export var pushForce : float = 80.0
@export var CHARGING_SPEED : float = 1.0

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

signal started_charging
signal stopped_charging
signal landed_on_ground

var is_charging_jump = false
var jump_velocity = 0.0
var is_grounded = false

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_C):
		GameManager.reaload_scene()

func _physics_process(delta: float) -> void:
	var actual_speed = SPEED
	
	if not is_grounded and is_on_floor():
		landed_on_ground.emit()
	
	is_grounded = is_on_floor()
	
	# Add the gravity.                               
	if !is_grounded:
		velocity += get_gravity() * delta
		actual_speed *= SPEED_MULT_WHILE_IN_AIR

	# Handle jump.
	if Input.is_action_just_pressed("jump") and GameGlobals.userHasControl:
		started_charging.emit()
		is_charging_jump = true
		jump_velocity = BASE_JUMP_VELOCITY
		
	if is_charging_jump and jump_velocity > MAX_JUMP_VELOCITY:
		jump_velocity -= 5 * CHARGING_SPEED

	if Input.is_action_just_released("jump") and GameGlobals.userHasControl:
		stopped_charging.emit()
		is_charging_jump = false
		
		if is_grounded:
			velocity.y = jump_velocity
			AudioManager.play_sound(AudioResource.SoundEffect.PLAYER_JUMP)
		
		jump_velocity = 0.0
		
	
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction and GameGlobals.userHasControl:
		
		if !is_grounded:
			actual_speed *= SPEED_MULT_WHILE_IN_AIR
		elif is_charging_jump :
			actual_speed *= SPEED_MULT_WHILE_CHARGING
		
		velocity.x = direction * actual_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var coll = get_slide_collision(i)
		if coll.get_collider() is RigidBody2D:
			(coll.get_collider() as RigidBody2D).apply_central_impulse(-coll.get_normal() * pushForce)
