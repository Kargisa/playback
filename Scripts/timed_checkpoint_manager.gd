extends Node

class_name TimedObjectiveManager

@export var time : float = 10.0

var objectives : Array[TimedObjective]
var collectedObjectives : Array[TimedObjective]

@onready var timer : Timer = $Timer

signal onObjectivesCollected

func allObjectivesCollected() -> void:
	print("All Objectives Collected")
	onObjectivesCollected.emit()
	
func failedToCollectAllObjectives() -> void:
	print("Faild to collect all objectives")
	
	for objective in collectedObjectives:
		objective.resetObjective()
	
	collectedObjectives.clear()

func onTimerFinished() -> void:
	if collectedObjectives.size() < objectives.size():
		failedToCollectAllObjectives()
		return

func onCkeckpointEnter(objective: TimedObjective) -> void:
	if collectedObjectives.size() <= 0:
		timer.start(time)
		
	if collectedObjectives.has(objective):
		return
		
	collectedObjectives.append(objective)
	objective.collectObjective()
	
	print("Objective Collected")
	
	if collectedObjectives.size() >= objectives.size():
		allObjectivesCollected()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(onTimerFinished)
	
	for child in get_children():
		if child is TimedObjective:
			var objective = child as TimedObjective
			objective.onObjectiveEnter.connect(onCkeckpointEnter)
			objectives.append(objective)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
