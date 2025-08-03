extends Node2D
class_name RecordingTrigger

var recording_manager : RecordingManager
@export var recording_id : int

func _on_recording_button_on_button_pressed() -> void:
	print(recording_manager)
	recording_manager.start_recording(recording_id)
