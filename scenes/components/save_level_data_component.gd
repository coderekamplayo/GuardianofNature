class_name SaveLevelDataComponent
extends Node

var level_scene_name: String
var save_game_data_path: String = "user://game_data/"
var save_file_name: String = "save_%s_game_data.tres"
var game_data_resource: SaveGameDataResource

# [NEW] Local list to track destroyed objects during this session
var current_removed_paths: Array[String] = []

func _ready() -> void:
	add_to_group("save_level_data_component")
	level_scene_name = get_parent().name

# [NEW] Call this function from trees/rocks before queue_free()
func on_object_destroyed(node: Node) -> void:
	var path = String(node.get_path())
	if not current_removed_paths.has(path):
		current_removed_paths.append(path)

func save_node_data() -> void:
	var nodes = get_tree().get_nodes_in_group("save_data_component")
	game_data_resource = SaveGameDataResource.new()
	
	# [NEW] Save the list of destroyed objects
	game_data_resource.removed_node_paths = current_removed_paths
	
	if nodes != null:
		for node in nodes:
			# Check if node has save_data method (supports both SaveDataComponent and TimeSaveDataComponent)
			if node.has_method("save_data"):
				var save_data_resource: NodeDataResource = node.save_data()
				if save_data_resource:
					var save_final_resource = save_data_resource.duplicate()
					game_data_resource.save_data_nodes.append(save_final_resource)

func save_game() -> void:
	# ... (Keep existing directory creation logic) ...
	var level_save_file_name: String = save_file_name % level_scene_name
	save_node_data()
	ResourceSaver.save(game_data_resource, save_game_data_path + level_save_file_name)

func load_game() -> void:
	var level_save_file_name: String = save_file_name % level_scene_name
	var save_game_path: String = save_game_data_path + level_save_file_name
	
	if !FileAccess.file_exists(save_game_path):
		return
	
	game_data_resource = ResourceLoader.load(save_game_path)
	if game_data_resource == null: return
	
	var root_node: Window = get_tree().root
	
	# [NEW] Delete objects that were destroyed in the save file
	current_removed_paths = game_data_resource.removed_node_paths
	for node_path_string in current_removed_paths:
		var node_to_remove = root_node.get_node_or_null(node_path_string)
		if node_to_remove != null:
			node_to_remove.queue_free()
	
	# Apply data to remaining objects
	for resource in game_data_resource.save_data_nodes:
		if resource is NodeDataResource:
			resource._load_data(root_node)
