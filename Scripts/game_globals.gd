extends Node

var userHasControl = true
var isRewinding = false

func set_time_scale(scale: float) -> void:
	Engine.time_scale = scale

func set_player_control(control: bool) -> void:
	userHasControl = control

func set_rewinding(r: bool) -> void:
	userHasControl = not r
	isRewinding = r

func show_mouse(show : bool) -> void:
	if show:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func pause_game() -> void:
	set_time_scale(0.0)
	set_player_control(false)
	show_mouse(true)

func unpause_game() -> void:
	set_time_scale(1.0)
	set_player_control(true)
	show_mouse(false)
