extends Node2D


@export var sprite_frames: SpriteFrames:
	set(value):
		sprite_frames = value
		if sprite_node:
			sprite_node.sprite_frames = sprite_frames

@export var sprite_node: AnimatedSprite2D
@export var mood_node: AnimatedSprite2D
@export var expr_node: AnimatedSprite2D

@export var mood_level_curve: Dictionary[String,Vector2i] = {
	"Angry": Vector2i(0,20),
	"Sad": Vector2i(21,40),
	"Neutral": Vector2i(41,80),
	"Happy": Vector2i(81,100),
}

var _mood_level: int
@export var mood_level: int = 50:
	set(value):
		_mood_level = value
		var mood_ind:int = mood_level_curve.values().find_custom(func(c): return mood_level>=min(c.x,c.y) and mood_level<=max(c.x,c.y))
		mood = mood_level_curve.keys()[mood_ind]
	get():
		return _mood_level


enum Mood {Happy, Neutral, Sad, Angry}
var mood: Mood = Mood.Happy:
	set(value):
		mood = value
		match mood:
			Mood.Happy:
				sprite_node.play("Happy")
				mood_node.play("Happy")
				expr_node.visible = false
			Mood.Neutral:
				sprite_node.play("Neutral")
				mood_node.play("Neutral")
				expr_node.visible = false
			Mood.Sad:
				sprite_node.play("Sad")
				mood_node.play("Sad")
				expr_node.visible = true
				expr_node.play("Angry 1")
			Mood.Angry:
				sprite_node.play("Sad")
				mood_node.play("Angry")
				expr_node.visible = true
				expr_node.play("Angry 2")


func _ready() -> void:
	sprite_frames = sprite_frames
