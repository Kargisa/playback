extends Node

class_name LevelManager

@export var door : LevelFinishedDoor
@export var buttons : Array[InteractButton]
@export var timedObjectives : Array[TimedObjectiveManager]

var objectivesCompleted = 0 

func buttonPressed() -> void:
	objectivesCompleted += 1
	
func buttonReleased() -> void:
	objectivesCompleted -= 1

func timedObjectiveComplete() -> void:
	objectivesCompleted += 1
	
func timedObjectiveFailed() -> void:
	objectivesCompleted -= 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.showMouse(false)
	for button in buttons:
		button.onButtonPressed.connect(buttonPressed)
		button.onButtonReleased.connect(buttonReleased)
		
	for objective in timedObjectives:
		objective.onObjectivesCollected.connect(timedObjectiveComplete)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if objectivesCompleted >= buttons.size() + timedObjectives.size():
		door.isOpen = true
	else:
		door.isOpen = false
