extends Node2D

class_name LevelFinishedDoor

@export var player: CharacterBody2D
@export var nextLevel : String

@onready var area: Area2D = $Area2D
@onready var sprite: Sprite2D = $Sprite2D

var isOpen : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if isOpen:
		sprite.frame = 1
	else:
		sprite.frame = 0
	
	if not area.overlaps_body(player):
		return
		
	if not isOpen and Input.is_action_just_pressed("interact"):
		AudioManager.play_sound(AudioResource.SoundEffect.DOOR_KNOCK)
	elif isOpen and Input.is_action_just_pressed("interact") and player.is_on_floor():
		GameManager.load_scene(nextLevel)
		
