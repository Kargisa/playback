extends Resource

class_name AudioResource

enum SoundEffect {
	PLAYER_JUMP,
	PLAYER_EAT,
	BUTTON_PRESSED,
	BUTTON_RELEASED,
	DOOR_KNOCK
}

@export var stream : AudioStreamMP3
@export var type : SoundEffect
@export_range(-40, 20) var volume : int = 0
@export_range(0.0, 4.0, 0.01) var pitchRandomnessLower = 1.0
@export_range(0.0, 4.0, 0.01) var pitchRandomnessHigher = 1.0
