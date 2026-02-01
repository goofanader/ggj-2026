extends PanelContainer
class_name DialogText

@export var color: Color = Color.WHITE:
	set(value):
		color = value
		color_node.color = color
@export_multiline var text: String:
	set(value):
		text = value
		rich_text_node.text = text

@export var rich_text_node: RichTextLabel
@export var color_node: ColorRect
