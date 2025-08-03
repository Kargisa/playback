extends Node2D

class_name InteractButton

@export var releaseDelay : float = 0.0
var timeSinceAreaExited : float = 0.0
var areaExited = false
var nodesOnButton : int = 0

@onready var area : Area2D = $Area2D
@onready var sprite : Sprite2D = $Sprite2D

signal onButtonPressed
signal onButtonReleased

func pressButton() -> void:
	sprite.frame = 1
	AudioManager.play_sound(AudioResource.SoundEffect.BUTTON_PRESSED)
	onButtonPressed.emit()

func releaseButton() -> void:
	sprite.frame = 0
	AudioManager.play_sound(AudioResource.SoundEffect.BUTTON_RELEASED)
	onButtonReleased.emit()
	

func onAreaEntered(node : Node) -> void:
	if node.is_in_group("button_interact"):
		nodesOnButton += 1
		if nodesOnButton == 1:
			pressButton()
	

func onAreaExited(node : Node) -> void:
	if node.is_in_group("button_interact"):
		nodesOnButton -= 1
		if nodesOnButton == 0:
			timeSinceAreaExited = 0.0
			areaExited = true
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.body_entered.connect(onAreaEntered)
	area.body_exited.connect(onAreaExited)
	
func _process(delta: float) -> void:
	if not areaExited:
		return
	
	if timeSinceAreaExited < releaseDelay:
		timeSinceAreaExited += delta
		return
	
	areaExited = false
	releaseButton()
	pass
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
