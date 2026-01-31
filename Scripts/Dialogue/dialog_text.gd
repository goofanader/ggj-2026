extends Control

@onready var label: RichTextLabel = $RichTextLabel

signal clicked(entry)

func set_text(t: String) -> void:
	label.text = t

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		emit_signal("clicked", self)
