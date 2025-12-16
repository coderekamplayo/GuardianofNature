class_name TileMapLayerDataResource
extends NodeDataResource

@export var tilemap_layer_used_cells: Array[Vector2i]
@export var terrain_set: int = 0
@export var terrain: int = 0 # 0 usually represents the Tilled Soil ID in your tileset

func _save_data(node: Node2D) -> void:
	# Save the basic node data (position, etc)
	super._save_data(node)
	
	if node is TileMapLayer:
		# Save exactly which cells have tiles on them
		tilemap_layer_used_cells = node.get_used_cells()

func _load_data(window: Window) -> void:
	var node = window.get_node_or_null(node_path)
	
	if node is TileMapLayer:
		# 1. Clear the layer to remove default state
		node.clear()
		
		# 2. Re-paint the tiles based on the saved data using autotile connections
		if tilemap_layer_used_cells.size() > 0:
			node.set_cells_terrain_connect(tilemap_layer_used_cells, terrain_set, terrain, true)
