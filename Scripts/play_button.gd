extends Button

class_name PlayButton

var baseMenu : BaseMenu

func _on_pressed() -> void:
	GameManager.showMouse(false)
	GameManager.playerControl(true)
	GameManager.setTimeScale(1)
	baseMenu.visible = false
