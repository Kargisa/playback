extends Node

@export var player : CharacterBody2D
@export var recordTime : float = 2.0
@export var revertSpeed : float = 1.5
@export var waitTime : float = 1.0
var recordingBody = preload("res://Scenes/recording_body.tscn")


var recordLength : float = 0.0
var recording : Array[Vector2]

var isRecording : bool = false
var isPlaying : bool = false
var isReverting : bool = false

var revertIndex : float = -1

func onReplayFinish():
	isPlaying = false

func _physics_process(delta: float) -> void:
	if isReverting:
		if revertIndex < 0:
			isReverting = false
			return
		
		player.global_position = recording[revertIndex]
		revertIndex -= revertSpeed
		return
	
	if !isRecording:
		return
	
	recording.append(player.global_position)
	recordLength += delta;
	
	if recordLength > recordTime:
		print("recording finished")
		isRecording = false
		isReverting = true
		revertIndex = recording.size() - 1
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("start_recording") and GameGlobals.userHasControl:
		print("start recording")
		recording.clear()
		recordLength = 0
		isRecording = true
	elif Input.is_action_just_pressed("play_recording") and !isRecording and !isPlaying and GameGlobals.userHasControl:
		print("play recording")
		isPlaying = true
		var instance = recordingBody.instantiate()
		var recordBody = (instance as Recording_Body)
		recordBody.recording = recording
		recordBody.waitTime = waitTime
		recordBody.onFinish = Callable(self, "onReplayFinish")
		(instance as CharacterBody2D).global_position = recording[0]
		add_child(instance)
		
