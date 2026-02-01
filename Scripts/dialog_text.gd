extends Control

@export var text: String = "":
	set(value):
		text = value
		label_node.text = text


@export var label_node: Label
