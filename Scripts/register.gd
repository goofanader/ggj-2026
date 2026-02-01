extends Sprite2D

signal scan
signal checkout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_scan_spot_area_area_entered(_area: Area2D) -> void:
	$Beeper.play()
	scan.emit()


func _on_click_box_input_event(viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
			$KaChing.play()
			checkout.emit()
			viewport.set_input_as_handled()
