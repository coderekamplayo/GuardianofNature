class_name SaveGameDataResource
extends Resource

@export var save_data_nodes: Array[NodeDataResource]
# [NEW] List of paths to objects that have been destroyed (e.g. cut trees)
@export var removed_node_paths: Array[String] = []
