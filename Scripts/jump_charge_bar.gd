extends TextureProgressBar

class_name JumpChargeBar

var player : PlayerMovement

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	value = (player.jump_velocity - player.BASE_JUMP_VELOCITY) / (player.MAX_JUMP_VELOCITY - player.BASE_JUMP_VELOCITY) * 100.0
	pass
