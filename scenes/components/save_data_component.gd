class_name SaveDataComponent
extends Node

@onready var parent_node: Node2D = get_parent() as Node2D

@export var save_data_resource: Resource

func _ready() -> void:
	add_to_group("save_data_component")


func save_data() -> Resource:
	if parent_node == null:
		return null
	
	if save_data_resource == null:
		push_error("Error: No save_data_resource on " + parent_node.name)
		return null
	
	if !save_data_resource.has_method("_save_data"):
		print("ERROR: The resource on '", parent_node.name, "' is missing the script!")
		return null
	
	save_data_resource._save_data(parent_node)
	
	return save_data_resource
