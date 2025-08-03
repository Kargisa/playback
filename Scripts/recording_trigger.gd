extends Node2D
class_name RecordingTrigger

@export var recording_manager : RecordingManager
@export var recording_id : int

func _on_button_on_button_pressed() -> void:
	recording_manager.start_recording(recording_id)

func _on_button_on_button_released() -> void:  
	pass
	
