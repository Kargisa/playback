extends TextureRect

class_name PocketWatch

@export var textures : Array[Texture2D]
var recording_manager : RecordingManager

var rewindTime
var timeSinceRewindStart = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if recording_manager.state != RecordingManager.State.RECORDING and recording_manager.state != RecordingManager.State.REWINDING:
		hide()
		return
	
	show()
	
	if recording_manager.state == RecordingManager.State.REWINDING:
		rewindTime = recording_manager.timer.wait_time / recording_manager.rewind_speed
		timeSinceRewindStart += delta
		texture = textures[(1.0 - timeSinceRewindStart / rewindTime) * textures.size() - 1]
		return
	else:
		timeSinceRewindStart = 0.0
	
	
	texture = textures[abs(((recording_manager.timer.wait_time - recording_manager.timer.time_left) / recording_manager.timer.wait_time) * (textures.size()))]
