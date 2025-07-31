extends Node2D

class_name TimedCheckpoint


@export var radius : float = 10.0

@onready var collider : CollisionShape2D = $Area2D/CollisionShape2D
@onready var area : Area2D = $Area2D

signal onCheckpintEnter

func onBodyEnter(body: Node) -> void:
	if body is not CharacterBody2D:
		return
	
	onCheckpintEnter.emit(self)
	pass

func _ready() -> void:
	(collider.shape as CircleShape2D).radius = radius
	area.body_entered.connect(onBodyEnter)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		(collider.shape as CircleShape2D).radius = radius
		
func _physics_process(_delta: float) -> void:
	pass
