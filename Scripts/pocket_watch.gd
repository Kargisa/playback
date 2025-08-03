extends TextureRect

class_name PocketWatch

@export var textures : Array[Texture2D]
var recording_manager : RecordingManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if recording_manager.state != RecordingManager.State.RECORDING:
		hide()
		return
	
	show()
	
	texture = textures[(recording_manager.timer.wait_time - recording_manager.timer.time_left) / recording_manager.timer.wait_time * (textures.size())]
