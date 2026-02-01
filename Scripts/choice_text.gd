extends PanelContainer
class_name ChoiceText

@export_multiline var text: String:
	set(value):
		text = value
		rich_text_node.text = text

@export var rich_text_node: RichTextLabel

@export var player_damage: int = 0
@export var customer_damage: int = 0

func load_data(data:ChoiceData) -> void:
	text = data.text
	player_damage = data.player_damage
	customer_damage = data.customer_damage


signal clicked(text, player_damage, customer_damage)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			self.accept_event()
			picked()


func picked() -> void:
	print("Clicked Choice: %s"%text)
	clicked.emit(text, player_damage, customer_damage)
