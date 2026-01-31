extends Node2D

@export var item_scene: PackedScene

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Quit"):
		get_tree().quit()


func drop_items() -> void:
	#Assuming max items is 3
	var n_items = 3#randi_range(1,3)
	for i in range(n_items):
		var item = item_scene.instantiate()
		item.initialize($Fg/ItemDrops.get_child(i).position)
		print("Position ",i," ",$Fg/ItemDrops.get_child(i).position) 
		$Fg.add_child(item)
