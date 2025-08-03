extends Node

@onready var restartProgressBar : TextureProgressBar

var userHasControl = true
var playerIsRewinding = false

const timeToHoldRestart : float = 3.0
var timeSinceRestartHeld : float = 0.0

func quit() -> void:
	get_tree().quit()

func setTimeScale(scale: float) -> void:
	Engine.time_scale = scale
	
func set_player_rewinding(r: bool) -> void:
	GameManager.playerIsRewinding = r

func playerControl(control: bool) -> void:
	userHasControl = control

func showMouse(show : bool) -> void:
	if show:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
func load_scene(path : String) -> void:
	get_tree().change_scene_to_file(path)
	
func reaload_scene() -> void:
	get_tree().reload_current_scene()
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		GameManager.quit()
	
	if Input.is_key_pressed(KEY_R):
		if GameManager.timeSinceRestartHeld >= GameManager.timeToHoldRestart:
			GameManager.reaload_scene()
			return
		
		GameManager.timeSinceRestartHeld += delta
	else:
		GameManager.timeSinceRestartHeld = 0.0

	GameManager.restartProgressBar.value = GameManager.timeSinceRestartHeld / GameManager.timeToHoldRestart * 100.0
