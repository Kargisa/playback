extends Node

@export var sounds : Array[AudioResource]

var sounds_dic : Dictionary
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for sound in sounds:
		sounds_dic[sound.type] = sound

func play_sound(type: AudioResource.SoundEffect):
	if not sounds_dic.has(type):
		push_error("No Sound Effect Of Type")
	
	var resource : AudioResource = sounds_dic[type]
	var stream_player : AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(stream_player)
	
	stream_player.stream = resource.stream
	stream_player.volume_db = resource.volume
	stream_player.pitch_scale = rng.randf_range(resource.pitchRandomnessLower, resource.pitchRandomnessHigher)
	stream_player.finished.connect(stream_player.queue_free)
	
	stream_player.play()
