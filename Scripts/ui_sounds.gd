extends AudioStreamPlayer

var hover_sound = preload("res://Assets/Sounds/Select_4.ogg")
var press_sound = preload("res://Assets/Sounds/Confirm_1.ogg")

# Instructions: Add buttons to "Button" group and they will make sound!

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var buttons: Array = get_tree().get_nodes_in_group("Button")
	for inst in buttons:
		inst.connect("pressed",on_button_pressed)
		inst.connect("mouse_entered",on_button_hovered)

func on_button_pressed() -> void:
	stream = press_sound
	play()

func on_button_hovered() -> void:
	stream = hover_sound
	play()
