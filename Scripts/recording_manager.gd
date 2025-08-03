extends Node

class_name RecordingManager

@export var ghost_scene : PackedScene

enum State {
	IDLE,
	PLAYING,
	RECORDING,
	REWINDING,
	PAUSED
}

signal stopped_rewinding

@onready var timer: Timer = $Timer

@export var rewind_speed: float = 1.0
@export var recording_time: float = 5.0

@export var ghosts_node : Node
@export var player : CharacterBody2D
var player_sprite : PlayerAnimationManager
var objs : Array[Node] = []
var initial_objs : Array[Node]

var player_recordings : Dictionary[int, Array] = {}
var object_recordings : Dictionary[int, Array] = {}

var ghosts : Dictionary[int, CharacterBody2D]

var state : State = State.IDLE
var should_rewind_player : bool = false
var recording_id : int = -1
var current_frame : int = 0
var frames_recorded : int = 0

func _ready() -> void:
	for child in get_children():
		if child is RecordingTrigger:
			(child as RecordingTrigger).recording_manager = self
			
	timer.wait_time = recording_time

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("play_recording"):
		if player_recordings.is_empty():
			return
		
		match state:
			State.PLAYING:
				# TODO rewind_ghosts and set to idle
				return
			State.IDLE:
				pass
			_:
				return
		
		spawn_ghosts()	
		state = State.PLAYING
		current_frame = 0
	if Input.is_action_just_pressed("pause_playback"):
		match state:
			State.PLAYING:
				state = State.PAUSED
			State.PAUSED:
				state = State.PLAYING

func _physics_process(delta: float) -> void:
	match state:
		State.RECORDING:
			record_player()
			record_objects()
			
			playback_ghosts()
			
			current_frame += 1
		State.REWINDING:
			current_frame -= 1 * rewind_speed
			
			if should_rewind_player:
				rewind_player()
			if !ghosts.is_empty():
				playback_ghosts()
			
			rewind_objects()
			
			if current_frame <= 0: 
				stop_rewinding()
				clear_ghosts()
				return
		State.PLAYING:
			if current_frame >= frames_recorded - 1:
				start_rewinding(false)
				return
			
			playback_ghosts()
			record_objects()
			
			current_frame += 1
		State.PAUSED:
			return
		
	
func record_player() -> void:
	var data = FrameData.new(
		player.global_position,
		player.global_rotation,
		player_sprite.flip_h,
		player_sprite.animation,
		player_sprite.frame
	)
	
	if current_frame == 0:
		player_recordings[recording_id] = [data]
	else:
		player_recordings[recording_id].append(data)
	

func rewind_player() -> void:
	var data = player_recordings[recording_id][current_frame] as FrameData
	
	player.global_position = data.position
	player.global_rotation = data.rotation
	player_sprite.flip_h = data.flip_h
	player_sprite.animation = data.animation_name
	player_sprite.frame = data.animation_frame

func record_objects() -> void:
	for obj in objs:
		var obj_id = obj.get_instance_id()
		
		var data = FrameData.new(
			obj.global_position,
			obj.global_rotation,
			false,
			"",
			0
		)
		
		if current_frame == 0:
			object_recordings[obj_id] = [data]
		else:
			object_recordings[obj_id].append(data)

func rewind_objects() -> void:
	for obj in objs:
		var obj_id = obj.get_instance_id()
		
		var data = object_recordings[obj_id][current_frame] as FrameData
		
		if obj is RigidBody2D:
			obj.set_deferred("global_position", data.position)
			obj.set_deferred("global_rotation", data.rotation)
			obj.set_deferred("linear_velocity", Vector2.ZERO)
			obj.set_deferred("angular_velocity", 0.0)
		else:
			obj.global_position = data.position
			obj.global_rotation = data.rotation

func playback_ghosts() -> void:
	for key in player_recordings:
		if key == recording_id:
			continue
		
		if player_recordings[key].size() <= current_frame:
			continue
		
		var data = player_recordings[key][current_frame] as FrameData
		
		var ghost = ghosts[key]
		var ghost_sprite = ghost.find_child("AnimatedSprite2D") as AnimatedSprite2D

		ghost.global_position = data.position
		ghost.global_rotation = data.rotation
		if ghost_sprite:
			ghost_sprite.flip_h = data.flip_h
			ghost_sprite.animation = data.animation_name
			ghost_sprite.frame = data.animation_frame

func rewind_ghosts() -> void:
	pass
	
func start_recording(rec_id: int) -> void:
	if !state == State.IDLE:
		return
	
	if not player:
		print("no player to record")
		return
	
	player_sprite = player.find_child("AnimatedSprite2D")
	objs = get_tree().get_nodes_in_group("rewindables")
	initial_objs = objs
	
	if not player_sprite:
		print("couldn't get player sprite")
		return
	
	recording_id = rec_id
	if player_recordings.get(recording_id):
		player_recordings[recording_id].clear()
	
	spawn_ghosts()
	
	current_frame = 0
	state = State.RECORDING
	
	timer.start()
	
	print("started recording ", rec_id)

func stop_recording() -> void:
	should_rewind_player = true
	frames_recorded = player_recordings[recording_id].size()
	print("stopped recording ", current_frame)

func start_rewinding(rewind_player: bool) -> void:
	#disable_objects_collisions(true)
	freeze_rigidbodies(true)
	GameManager.set_player_rewinding(rewind_player)
	GameManager.playerControl(not rewind_player)
	should_rewind_player = rewind_player
	state = State.REWINDING
	
	print("start rewinding")

func stop_rewinding() -> void:
	#disable_objects_collisions(false)
	freeze_rigidbodies(false)
	
	current_frame = 0
	recording_id = -1
	state = State.IDLE
	GameManager.set_player_rewinding(false)
	GameManager.playerControl(true)
	player_sprite.reset_to_idle() # BIST DU DEPPAT ICCH HASSE MEINEN CODE EINFACCH VERBRENNSNENNESKDJN
	object_recordings.clear()

func spawn_ghosts() -> void:
	for i in player_recordings:
		if i == recording_id:
			continue
		
		var ghost = ghost_scene.instantiate() as CharacterBody2D
		ghost.global_position = player_recordings[i][0].position
		ghosts_node.add_child(ghost)
		ghosts[i] = ghost
		
func clear_ghosts() -> void:
	for ghost in ghosts:
		ghosts[ghost].queue_free()
	ghosts.clear()

func disable_objects_collisions(value: bool) -> void:
	for obj in objs:
		var collision_shape = obj.find_child("CollisionShape2D")
		if !collision_shape:
			print("Couldn't get objects colission shape")
			continue
		collision_shape.set_deferred("disabled", value)

func freeze_rigidbodies(frozen: bool) -> void:
	for obj in objs:
		if obj is RigidBody2D:
			obj.freeze = frozen
			if not frozen:
				var initial_idx = initial_objs.find_custom(is_ein_jürgen.bind(obj.get_instance_id()))
				var initial = initial_objs[initial_idx]
				obj.global_position = initial.global_position
				obj.global_rotation = initial.global_rotation
				obj.linear_velocity = Vector2.ZERO
				obj.angular_velocity = 0.0

func is_ein_jürgen(object: Node, id: int) -> bool:
	return object.get_instance_id() == id

func _on_timer_timeout() -> void:
	stop_recording()
	start_rewinding(true)
	GameManager.playerControl(false)
