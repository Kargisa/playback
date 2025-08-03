extends Resource
class_name FrameData
 
@export var position : Vector2
@export var rotation : float
@export var flip_h : bool
@export var animation_name : String
@export var animation_frame : int

func _init(p_position: Vector2, p_rotation: float, p_flip_h: bool, p_animation_name: String, p_animation_frame: int) -> void:
	position = p_position
	rotation = p_rotation
	flip_h = p_flip_h
	animation_name = p_animation_name
	animation_frame = p_animation_frame
