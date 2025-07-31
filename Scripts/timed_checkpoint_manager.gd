extends Node

class_name TimedCheckpointManager

var checkpoints : Array[TimedCheckpoint]

func onCkeckpointEnter() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is TimedCheckpoint:
			var checkpoint = child as TimedCheckpoint
			checkpoint.onCheckpintEnter.connect(onCkeckpointEnter)
			checkpoints.append(checkpoint)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
