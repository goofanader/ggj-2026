extends Node
class_name BackgroundSoundPlayer

@export var looping_audio_tracks: Array[AudioStream] = []
@export var frequent_audio_tracks: Array[FrequentAudioData] = []

class VariableTimer extends Timer:
	var period: Vector2
	var timer: Timer
	func _init() -> void:
		one_shot = true
		timeout.connect(restart_variable)
	func start_variable():
		start(randf_range(0,(period[0]+period[1])/2))
	func restart_variable():
		start(randf_range(period[0],period[1]))


func _ready() -> void:
	
	for audio:AudioStream in looping_audio_tracks:
		var a: AudioStreamPlayer = AudioStreamPlayer.new()
		add_child(a)
		a.stream = audio
		a.play()
	
	for audio_data:FrequentAudioData in frequent_audio_tracks:
		var a: AudioStreamPlayer = AudioStreamPlayer.new()
		add_child(a)
		a.stream = audio_data.audio_track
		var t: VariableTimer = VariableTimer.new()
		add_child(t)
		t.period = audio_data.period
		t.timeout.connect(a.play)
		t.start_variable()
	
	
