extends Node2D
class_name CharacterStats

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

## -----------------------------------------------------------------------------
##             Node Attachements
## -----------------------------------------------------------------------------

@export_group("Node Attachements")
@export var sprite_node: AnimatedSprite2D
@export var bar_node: ProgressBar

## -----------------------------------------------------------------------------
##             External Data
## -----------------------------------------------------------------------------

@export_group("External Data")
var _mood_level: int = 100
@export var mood_level: int = 100:
	set(value):
		_mood_level = value
		var mood_ind:int = mood_level_curve.values().find_custom(func(c): return _mood_level<=c)
		mood = Mood.keys().find(mood_level_curve.keys()[mood_ind]) as Mood
		if _mood_level < 0:
			game_over.emit()
		if _mood_level > 100: _mood_level = 100
		bar_node.value = _mood_level
	get():
		return _mood_level

enum Mood {Happy, Neutral, Sad, Angry}
var mood: Mood = Mood.Happy:
	set(value):
		mood = value
		match mood:
			Mood.Happy:
				sprite_node.play("Happy")
			Mood.Neutral:
				sprite_node.play("Neutral")
			Mood.Sad:
				sprite_node.play("Sad")
			Mood.Angry:
				sprite_node.play("Angry")

## -----------------------------------------------------------------------------
##             Base Methods
## -----------------------------------------------------------------------------

func _ready() -> void:
	mood_level = mood_level

## -----------------------------------------------------------------------------
##             Signals
## -----------------------------------------------------------------------------

signal game_over

## -----------------------------------------------------------------------------
##             Methods
## -----------------------------------------------------------------------------

func damage(value:float) -> void:
	mood_level -= roundi(value)
	
