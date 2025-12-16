class_name InventoryDataResource
extends NodeDataResource

@export var inventory_data: Dictionary

func _save_data(node: Node) -> void:
	# Grab the dictionary directly from the Manager
	inventory_data = InventoryManager.inventory

func _load_data(window: Window) -> void:
	# Put the data back into the Manager
	InventoryManager.inventory = inventory_data
	
	# !!! IMPORTANT !!! 
	# We must tell the UI that the inventory changed, otherwise the icons won't appear
	InventoryManager.inventory_changed.emit()
