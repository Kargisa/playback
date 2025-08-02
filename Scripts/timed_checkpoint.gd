extends Node2D

class_name TimedObjective


@onready var collider : CollisionShape2D = $Area2D/CollisionShape2D
@onready var area : Area2D = $Area2D

signal onObjectiveEnter

func collectObjective() -> void:
	hide()
	pass

func resetObjective() -> void:
	show()
	pass

func onBodyEnter(body: Node) -> void:
	if body is not CharacterBody2D:
		return
	
	onObjectiveEnter.emit(self)
	pass

func _ready() -> void:
	area.body_entered.connect(onBodyEnter)

func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	pass
