extends Node2D

class_name TimedCheckpoint


@onready var collider : CollisionShape2D = $Area2D/CollisionShape2D
@onready var area : Area2D = $Area2D

signal onCheckpintEnter

func collectCheckpoint() -> void:
	hide()
	pass

func resetCheckpoint() -> void:
	show()
	pass

func onBodyEnter(body: Node) -> void:
	if body is not CharacterBody2D:
		return
	
	onCheckpintEnter.emit(self)
	pass

func _ready() -> void:
	area.body_entered.connect(onBodyEnter)

func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	pass
