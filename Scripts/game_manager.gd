extends Node

class_name GameManager

static var userHasControl = false

static func setTimeScale(scale: float) -> void:
	Engine.time_scale = scale

static func playerControl(control: bool) -> void:
	userHasControl = control

static func showMouse(show : bool) -> void:
	if show:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
