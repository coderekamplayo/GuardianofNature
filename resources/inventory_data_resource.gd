class_name InventoryDataResource
extends NodeDataResource

@export var inventory_data: Dictionary

func _save_data(node: Node) -> void:
	# [FIX] Use .duplicate() to create a snapshot of the inventory at this exact moment.
	# Without this, the saved data keeps updating as you play!
	inventory_data = InventoryManager.inventory.duplicate()

func _load_data(window: Window) -> void:
	# Put the data back into the Manager
	InventoryManager.inventory = inventory_data
	
	# IMPORTANT: Update UI
	InventoryManager.inventory_changed.emit()
