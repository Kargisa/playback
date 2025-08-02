extends Control

class_name GameUI

@onready var baseMenu : BaseMenu = $MainMenu/BaseMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		GameManager.playerControl(false)
		GameManager.showMouse(true)
		GameManager.setTimeScale(0)
		baseMenu.visible = true
