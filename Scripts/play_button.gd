extends Button

class_name PlayButton

var baseMenu : BaseMenu

func _on_pressed() -> void:
	GameManager.showMouse(false)
	GameManager.playerControl(true)
	baseMenu.visible = false
