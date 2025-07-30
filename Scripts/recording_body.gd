extends CharacterBody2D

class_name Recording_Body

var recording : Array[Vector2]
var index : float = 0
var onFinish : Callable

var waitTime : float = 1.0
var timeWaited : float = 0

func smoothLerp(t: float) -> float:
	return -(cos(PI * t) - 1.0) / 2.0;


func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if timeWaited < waitTime:
		timeWaited += delta
		return
	
	if index >= recording.size():
		onFinish.call()
		queue_free()
		return
	
	global_position = recording[index]
	index += 1
	#move_and_slide()
