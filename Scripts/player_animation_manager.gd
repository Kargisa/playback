extends AnimatedSprite2D

@export var player_node: CharacterBody2D
@export var falling_velocity_thresholds : Array[float] = [120.0, 280.0]
@export var jumping_velocity_thresholds : Array[float] = [120.0, 200.0, 280.0]

enum PlayerState {
	IDLE,
	RUN,
	CHARGING,
	JUMP,
	FALLING,
	SPLAT,
	HURT,
	DIE
}

var current_state: PlayerState = PlayerState.IDLE
var player_is_charging: bool = false
var is_playing_splat: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_animation(current_state)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not player_node:
		return
	
	if player_node.velocity.x != 0:
			flip_h = player_node.velocity.x > 0
	
	update_velocity_based_animations()
	
	if is_playing_splat:
		return
	
	if player_node.is_on_floor():
		if player_is_charging:
			return
		
		if player_node.velocity.x != 0:
			set_state(PlayerState.RUN)
		else:
			set_state(PlayerState.IDLE)	
	else:
		if player_node.velocity.y < 0:
			set_state(PlayerState.JUMP)
		elif player_node.velocity.y > 0:
			set_state(PlayerState.FALLING)
	
func _on_player_started_charging() -> void:
	player_is_charging = true
	if not is_playing_splat and player_node.is_on_floor(): 
		set_state(PlayerState.CHARGING)

func _on_player_stopped_charging() -> void:
	player_is_charging = false

func _on_player_landed_on_ground() -> void:
	is_playing_splat = true
	set_state(PlayerState.SPLAT)

func _on_animation_finished() -> void:
	if current_state == PlayerState.SPLAT:
		is_playing_splat = false
		if player_is_charging:
			set_state(PlayerState.CHARGING)
		elif player_node.velocity.x != 0:
			set_state(PlayerState.RUN)
		else:
			set_state(PlayerState.IDLE)

func set_state(new_state):
	if current_state == new_state:
		return 
		
	current_state = new_state
	play_animation(current_state)
	
func update_velocity_based_animations():
	var speed_y = abs(player_node.velocity.y)
	
	match current_state:
		PlayerState.FALLING:
			set_velocity_based_frame("FALLING", speed_y, falling_velocity_thresholds, false)
		PlayerState.JUMP:
			set_velocity_based_frame("JUMP", speed_y, jumping_velocity_thresholds, true)

func set_velocity_based_frame(anim_name: String, speed: float, thresholds: Array[float], reverse_order: bool):
	var target_frame = 0
	
	for i in range(thresholds.size()):
		if speed >= thresholds[i]:
			target_frame = i + 1
	
	if reverse_order:
		var max_frame = sprite_frames.get_frame_count(anim_name) - 1
		target_frame = max_frame - target_frame
	
	target_frame = clamp(target_frame, 0, sprite_frames.get_frame_count(anim_name) - 1)
	frame = target_frame

func play_animation(state: PlayerState):
	var anim_name = "IDLE"
	
	match state:
		PlayerState.IDLE:
			anim_name = "IDLE"
		PlayerState.RUN:
			anim_name = "RUN"
		PlayerState.CHARGING:
			anim_name = "CHARGING"
		PlayerState.JUMP:
			anim_name = "JUMP"
		PlayerState.FALLING:
			anim_name = "FALLING"
		PlayerState.SPLAT:
			anim_name = "SPLAT"
		PlayerState.HURT:
			anim_name = "HURT"
		PlayerState.DIE:
			anim_name = "DIE"
	
	play(anim_name)
