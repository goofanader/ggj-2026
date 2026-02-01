extends PanelContainer
class_name ChoiceText

@export_multiline var text: String:
	set(value):
		text = value
		rich_text_node.text = text

@export var rich_text_node: RichTextLabel

@export var customer_response: String = ""
@export var player_damage: int = 0
@export var customer_damage: int = 0

var data: ChoiceData

func load_data(data_:ChoiceData) -> void:
	data = data_
	text = data.text
	customer_response = data.customer_response
	player_damage = data.player_damage
	customer_damage = data.customer_damage


signal clicked(choice)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			self.accept_event()
			picked()


func picked() -> void:
	print("Clicked Choice: %s"%text)
	clicked.emit(data)
