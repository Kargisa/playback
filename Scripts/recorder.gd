extends Area2D

@export var target: Player
@export var playback_asset : Texture2D
@export var rewind_speed_mult : float = 2.0

@onready var timer: Timer = $Timer

class RecordingData:
	var position : Vector2
	var flipped : bool
	var animation : String
	var animation_frame

var recording_data : Array[RecordingData]

var target_sprite : AnimatedSprite2D
var recording_time : float = 0.0
var is_recording : bool    = false
var target_inside: bool    = true

func _ready() -> void:
	if target:
		target_sprite = target.find_child("AnimatedSprite2D")
		if not target_sprite:
			push_warning("AnimatedSprite2D not found in target Player")

func _physics_process(delta: float) -> void:
	if not is_recording:
		return

	record()

func _process(_delta: float) -> void:
	if not target_inside:
		return
	
	if Input.is_action_just_pressed("start_recording"):
		recording_data.clear() # maybe different key for stop recording
		is_recording = true
		timer.start()

func record():
	#recording["position"].append(target.global_position)
	#recording["flipped"].append(target.velocity.x > 0)
	#recording["animation"].append(target_sprite.animation)
	#recording["animation_frame"].append(target_sprite.frame)

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	target_inside = true
	
func _on_body_exited(_body: Node2D) -> void:
	target_inside = false


func _on_timer_timeout() -> void:
	is_recording = false
