extends Node2D
class_name CustomerNode

## -----------------------------------------------------------------------------
##             Settings
## -----------------------------------------------------------------------------

@export_group("Settings and Data")
@export var mood_level_curve: Dictionary[String,int] = {
	"Angry": 20,
	"Sad": 40,
	"Neutral": 80,
	"Happy": 100,
}
@export var audio_files: Dictionary[String,AudioStream] = {}


## -----------------------------------------------------------------------------
##             Node Attachements
## -----------------------------------------------------------------------------

@export_group("Node Attachements")
@export var frame_node: Node2D
@export var sprite_node: AnimatedSprite2D
@export var expr_node: AnimatedSprite2D
@export var animator: AnimationPlayer
@export var audio_node: AudioStreamPlayer2D

## -----------------------------------------------------------------------------
##             External Data
## -----------------------------------------------------------------------------

@export_group("External Data")
@export var sprite_frames: SpriteFrames:
	set(value):
		sprite_frames = value
		if sprite_node:
			sprite_node.sprite_frames = sprite_frames

var _mood_level: int = 50
@export var mood_level: int = 50:
	set(value):
		_mood_level = value
		var mood_ind:int = mood_level_curve.values().find_custom(func(c): return _mood_level<=c)
		mood = Mood.keys().find(mood_level_curve.keys()[mood_ind]) as Mood
		if _mood_level < 0:
			leave(true)
		if _mood_level > 100: _mood_level = 100
	get():
		return _mood_level

@export var mood_scale: float = 1.0


enum Mood {Happy, Neutral, Sad, Angry}
var mood: Mood = Mood.Happy:
	set(value):
		mood = value
		match mood:
			Mood.Happy:
				sprite_node.play("Happy")
				expr_node.visible = false
			Mood.Neutral:
				sprite_node.play("Neutral")
				expr_node.visible = false
			Mood.Sad:
				sprite_node.play("Sad")
				expr_node.visible = true
				expr_node.play("Angry 1")
			Mood.Angry:
				sprite_node.play("Sad")
				expr_node.visible = true
				expr_node.play("Angry 2")


enum Transitions {Walk,Run,Beam,Blink}
@export var transition_in: Transitions = Transitions.Walk
@export var transition_out: Transitions = Transitions.Walk
@export var question: QuestionData
@export var customer_data: CustomerData


## -----------------------------------------------------------------------------
##             Signals
## -----------------------------------------------------------------------------

signal leaving(node, mad)
signal drop_item
signal ask_question(customer, question)
signal speak(text)

## -----------------------------------------------------------------------------
##             Methods
## -----------------------------------------------------------------------------

func entered() -> void:
	place_item()
	ask_question.emit(self,question)

func exited() -> void:
	var t: Timer = Timer.new()
	t.timeout.connect(queue_free)
	add_child(t)
	t.start(1.0)

func place_item() -> void:
	drop_item.emit()

func play_sound(sound_name:String) -> void:
	audio_node.stream = audio_files[sound_name]
	audio_node.play()

func enter() -> void:
	match transition_in:
		Transitions.Walk:
			animator.play("Walk In")
			$Customer_Frame/AudioStreamPlayer2D.volume_db = 0
		Transitions.Run:
			animator.play("Run In")
			$Customer_Frame/AudioStreamPlayer2D.volume_db = 0
		Transitions.Beam:
			animator.play("Beam In")
			$Customer_Frame/AudioStreamPlayer2D.volume_db = -7
		Transitions.Blink:
			animator.play("Blink In")
			$Customer_Frame/AudioStreamPlayer2D.volume_db = 0

var _is_leaving: bool = false
func leave(mad:bool=false) -> void:
	if _is_leaving: return
	_is_leaving = true
	speak.emit(customer_data.generate_farewell(self.mood))
	leaving.emit(self,mad)
	match transition_in:
		Transitions.Walk:
			animator.play("Walk Out")
			$Customer_Frame/AudioStreamPlayer2D.volume_db = 0
		Transitions.Run:
			animator.play("Run Out")
			$Customer_Frame/AudioStreamPlayer2D.volume_db = 0
		Transitions.Beam:
			animator.play("Beam Out")
			$Customer_Frame/AudioStreamPlayer2D.volume_db = -7
		Transitions.Blink:
			animator.play("Blink Out")
			$Customer_Frame/AudioStreamPlayer2D.volume_db = 0

func damage(value:float) -> void:
	mood_level -= roundi(value*mood_scale)


func _ready() -> void:
	sprite_frames = sprite_frames
	set_visible(false)
	mood_level = mood_level
