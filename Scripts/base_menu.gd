extends MarginContainer

class_name BaseMenu

@onready var playButton : PlayButton = $HBoxContainer/VBoxContainer2/PlayButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playButton.baseMenu = self
