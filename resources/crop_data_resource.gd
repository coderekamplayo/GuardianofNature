class_name CropDataResource
extends NodeDataResource

@export var growth_state: int
@export var scene_file_path: String

func _save_data(node: Node2D) -> void:
	# 1. Save standard position data
	super._save_data(node)
	
	# 2. Save the scene file path so we know what to spawn later (e.g., corn.tscn)
	if node.scene_file_path != "":
		scene_file_path = node.scene_file_path
	
	# 3. Save the growth state
	# We assume the node has a component or variable for this.
	# Adjust "growth_cycle_component" to match your actual component name variable
	if node.has_node("GrowthCycleComponent"):
		var growth_component = node.get_node("GrowthCycleComponent")
		growth_state = growth_component.current_growth_state

func _load_data(window: Window) -> void:
	# 1. Check if the node already exists (Static objects)
	var node = window.get_node_or_null(node_path)
	
	# 2. If node is missing (Dynamic objects like crops), SPAWN IT
	if node == null and scene_file_path != "":
		var parent_node = window.get_node_or_null(parent_node_path)
		if parent_node != null:
			var scene = load(scene_file_path)
			if scene:
				node = scene.instantiate()
				parent_node.add_child(node)
	
	# 3. Apply Data if node exists (or was just spawned)
	if node != null:
		node.global_position = global_position
		
		# Restore Growth State
		if node.has_node("GrowthCycleComponent"):
			var growth_component = node.get_node("GrowthCycleComponent")
			growth_component.current_growth_state = growth_state
			# Force the visual update
			if growth_component.has_method("set_growth_state"):
				growth_component.set_growth_state(growth_state)
