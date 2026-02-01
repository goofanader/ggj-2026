extends Resource
class_name  FrequentAudioData
	
@export var audio_track: AudioStream
@export var period: Vector2i = Vector2i(30,50):
	set(value):
		period = Vector2i(min(value[0],value[1]),max(value[0],value[1]))
