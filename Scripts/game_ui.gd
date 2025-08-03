extends Control

class_name GameUI
@export var player : PlayerMovement
@export var recording_manager : RecordingManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	GameManager.restartProgressBar = $GameUI/RestartBrogressBar
	($GameUI/JumpChargeBar as JumpChargeBar).player = player
	($GameUI/TextureRect as PocketWatch).recording_manager = recording_manager

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var tintColor : Color = Color(1.0, 1.0, 1.0, 0.0)
	
	tintColor.a = clamp(GameManager.timeSinceRestartHeld / GameManager.timeToHoldRestart * 2.0, 0.0, 1.0) 
	
	
	GameManager.restartProgressBar.tint_progress = tintColor
	GameManager.restartProgressBar.tint_under = tintColor
