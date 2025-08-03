extends Area2D

@export var label : Label

func onBodyEntered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	label.text = "Press P to replay"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(onBodyEntered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
