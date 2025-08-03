extends Node
class_name Recorder

signal finished_recording (rec_id: int)

var id : int
var target : Node2D
var is_recording : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if not is_recording:
		return
	pass

func record(r_target: Node2D, r_id: int):
	is_recording = true
	target = r_target
	id = r_id

	
