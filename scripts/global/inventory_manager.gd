extends Node

var inventory: Dictionary = {}

signal inventory_changed 

# --- SAVE SYSTEM VARIABLES ---
var save_data_resource: InventoryDataResource

func _ready() -> void:
	# 1. Register this manager to the Save System group
	add_to_group("save_data_component")
	
	# 2. Create the container for saving data
	save_data_resource = InventoryDataResource.new()

# --- SAVE SYSTEM FUNCTION ---
# This is called automatically when you click "Save"
func save_data() -> Resource:
	# This calls the function inside 'res://resources/inventory_data_resource.gd'
	save_data_resource._save_data(self)
	return save_data_resource

# --- INVENTORY LOGIC ---

func has_item(item_name: String) -> bool:
	if inventory.has(item_name):
		return inventory[item_name] > 0
	return false

func add_collectable(collectable_name: String) -> void:
	# If item exists, add 1. If not, create it at 1.
	if inventory.has(collectable_name):
		inventory[collectable_name] += 1
	else:
		inventory[collectable_name] = 1
	
	inventory_changed.emit()

func remove_collectable(collectable_name: String) -> void:
	# Safety check: Only try to remove if it exists
	if inventory.has(collectable_name):
		if inventory[collectable_name] > 0:
			inventory[collectable_name] -= 1
			
		# Optional: If you want to remove the key entirely when it hits 0
		# if inventory[collectable_name] == 0:
		# 	inventory.erase(collectable_name)
	
	inventory_changed.emit()
