extends Node2D
class_name MainNode

## -----------------------------------------------------------------------------
##             Data
## -----------------------------------------------------------------------------

@export_group("Game Data")
@export var customer_data: CustomerData

## -----------------------------------------------------------------------------
##             Node Attachements
## -----------------------------------------------------------------------------

@export_group("Node Attachments")
@export var customer_spawn: Marker2D
@export var item_spawn: Marker2D

## -----------------------------------------------------------------------------
##             Input
## -----------------------------------------------------------------------------

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Quit"):
		get_tree().quit()

## -----------------------------------------------------------------------------
##             Customer Methods
## -----------------------------------------------------------------------------

var customer_nodes: Array[CustomerNode] = []

func new_customer() -> void:
	var customer_node:CustomerNode = customer_data.generate_new()
	add_customer(customer_node)

func add_customer(customer_node) -> void:
	customer_nodes.append(customer_node)
	customer_node.main_node = self
	customer_node.position = customer_spawn.position
	add_child(customer_node)
	customer_node.enter()

func remove_customer(customer_node:CustomerNode) -> void:
	customer_nodes.erase(customer_node)
	customer_node.leave()
	
func clear_customers() -> void:
	for customer_node: CustomerNode in customer_nodes:
		remove_customer(customer_node)

## -----------------------------------------------------------------------------
##             Item Methods
## -----------------------------------------------------------------------------

var item_nodes: Array[Node]

func drop_items() -> void:
	#Assuming max items is 3
	var n_items = randi_range(1,3)
	for i in range(n_items):
		var item = item_scene.instantiate()
		item.initialize($Fg/ItemDrops.get_child(i).position)
		$Fg.add_child(item)

func place_item(item_node:Node) -> void:
	item_nodes.append(item_node)
	pass

func remove_item(item_node:Node) -> void:
	item_nodes.erase(item_node)
	item_node.queue_free()

func clear_items() -> void:
	for item_node:Node in item_nodes:
		remove_item(item_node)
