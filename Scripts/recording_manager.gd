extends Node

class_name RecordingManager

@export var ghost_scene : PackedScene

enum State {
	IDLE,
	PLAYING,
	RECORDING,
	REWINDING,
}

signal stopped_rewinding

@onready var timer: Timer = $Timer

@export var ghosts_node : Node
@export var player : CharacterBody2D
var player_sprite : PlayerAnimationManager
var objs : Array[Node] = []
var initial_objs : Array[Node]

var player_recordings : Dictionary[int, Array] = {}
var object_recordings : Dictionary[int, Array] = {}

var ghosts : Array[CharacterBody2D]

var state : State = State.IDLE
var should_rewind_player : bool = false
var recording_id : int = -1
var current_frame : int = 0
var frames_recorded : int = 0

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
		
		print("bingus")
		
		for i in player_recordings:
			var ghost = ghost_scene.instantiate() as CharacterBody2D
			
			ghost.global_position = player_recordings[i][0].position
			
			ghosts_node.add_child(ghost)
			ghosts.append(ghost)
			
		state = State.PLAYING

func _physics_process(delta: float) -> void:
	match state:
		State.RECORDING:
			record_player()
			record_objects()
			
			# TODO: playback_ghosts
			
			current_frame += 1
		State.REWINDING:
			current_frame -= 1
			
			if should_rewind_player:
				rewind_player()
			
			rewind_objects()
#			# rewind_ghosts()
			
			if current_frame <= 0: 
				stop_rewinding()
				return
		State.PLAYING:
			if current_frame >= frames_recorded:
				#start_rewinding()
				return
			
			playback_ghosts()
			record_objects()
		
	
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
		var data = player_recordings[key][current_frame] as FrameData

		#player.global_position = data.position
		#player.global_rotation = data.rotation
		#player_sprite.flip_h = data.flip_h
		#player_sprite.animation = data.animation_name
		#player_sprite.frame = data.animation_frame

	pass
	
func rewind_ghosts() -> void:
	pass
	
func start_recording(rec_id: int) -> void:
	if state == State.RECORDING or state == State.REWINDING:
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
	
	clear_recording_and_reset(rec_id)
	recording_id = rec_id
	current_frame = 0
	state = State.RECORDING
	
	timer.start()
	
	print("started recording ", rec_id)

func stop_recording() -> void:
	should_rewind_player = true
	frames_recorded = player_recordings[recording_id].size()
	print("stopped recording ", current_frame)

func clear_recording_and_reset(rec_id: int) -> void:
	print("clear recording", rec_id)
	
func start_rewinding() -> void:
	disable_objects_collisions(true)
	freeze_rigidbodies(true)
	GameGlobals.set_rewinding(true)
	state = State.REWINDING
	print("start rewinding")

func stop_rewinding() -> void:
	disable_objects_collisions(false)
	freeze_rigidbodies(false)
	
	current_frame = 0
	recording_id = -1
	state = State.IDLE
	GameGlobals.set_rewinding(false)
	player_sprite.reset_to_idle() # BIST DU DEPPAT ICCH HASSE MEINEN CODE EINFACCH VERBRENNSNENNESKDJN
	object_recordings.clear()

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
	start_rewinding()
