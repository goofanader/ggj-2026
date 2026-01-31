extends Node2D
class_name MainNode

## -----------------------------------------------------------------------------
##             Data
## -----------------------------------------------------------------------------

@export_group("Game Data")
@export var customer_data: CustomerData
var items = []
var scan_number: int

## -----------------------------------------------------------------------------
##             Node Attachements
## -----------------------------------------------------------------------------

@export_group("Attachments")
@export var customer_spawn: Marker2D
@export var item_scene: PackedScene

## -----------------------------------------------------------------------------
##             Input
## -----------------------------------------------------------------------------

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Quit"):
		get_tree().quit()
	elif event.is_action_pressed("Spawn New Customer"):
		new_customer()
	elif event.is_action_pressed("Clear Customers"):
		clear_customers()

## -----------------------------------------------------------------------------
##             Customer Methods
## -----------------------------------------------------------------------------

@export_group("Internal Variables")
@export var customer_nodes: Array[CustomerNode] = []

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

func drop_items() -> void:
	#Assuming max items is 3
	var n_items = randi_range(1,3)
	for i in range(n_items):
		var item = item_scene.instantiate()
		item.initialize($Fg/ItemDrops.get_child(i).position)
		$Fg.add_child(item)
		item.connect("mistake",_on_item_mistake)
		items.append(item)
	scan_number = 0


func _on_item_mistake(type: String) -> void:
	customer_nodes[0].damage(10) #Apply damage to customer TODO: Fix
	print("I am very angry")
	if type == "scan":
		print("You scanned that item twice")


## -----------------------------------------------------------------------------
##             Signal Methods
## -----------------------------------------------------------------------------

func _on_register_scan() -> void:
	scan_number += 1


func _on_register_checkout() -> void:
	if scan_number < items.size():
		customer_nodes[0].damage(10) #Apply damage to customer TODO: Fix
		print("What the heck you didn't scan all my stuff")
	for item in items:
		item.disconnect("mistake",_on_item_mistake)
		item.queue_free()
	items = []
	print("Bye Felicia")
	clear_customers()
