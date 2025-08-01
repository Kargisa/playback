extends Node

class_name TimedCheckpointManager

@export var time : float = 10.0

var checkpoints : Array[TimedCheckpoint]
var collectedCheckpoints : Array[TimedCheckpoint]

@onready var timer : Timer = $Timer

func allCheckpointsCollected() -> void:
	print("all checkpoints collected")
	
func failedToCollectAllCheckpoints() -> void:
	print("Faild to collect all checkpoints")
	
	for checkpoint in collectedCheckpoints:
		checkpoint.resetCheckpoint()
	
	collectedCheckpoints.clear()

func onTimerFinished() -> void:
	if collectedCheckpoints.size() < checkpoints.size():
		failedToCollectAllCheckpoints()
		return

func onCkeckpointEnter(checkpoint: TimedCheckpoint) -> void:
	if collectedCheckpoints.size() <= 0:
		timer.start(time)
		
	if collectedCheckpoints.has(checkpoint):
		return
		
	collectedCheckpoints.append(checkpoint)
	#checkpoint.collectCheckpoint()
	print("Checkpoint collected")
	
	if collectedCheckpoints.size() >= checkpoints.size():
		allCheckpointsCollected()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(onTimerFinished)
	
	for child in get_children():
		if child is TimedCheckpoint:
			var checkpoint = child as TimedCheckpoint
			checkpoint.onCheckpintEnter.connect(onCkeckpointEnter)
			checkpoints.append(checkpoint)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
