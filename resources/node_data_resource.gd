class_name NodeDataResource
extends Resource

@export var global_position: Vector2
@export var node_path: NodePath
@export var parent_node_path: NodePath

# Animation state for visual persistence
@export var animation_name: String = ""
@export var animation_position: float = 0.0
@export var blend_position: Vector2 = Vector2.ZERO


func _save_data(node: Node2D) -> void:
	global_position = node.global_position
	node_path = node.get_path()
	
	var parent_node = node.get_parent()
	if parent_node != null:
		parent_node_path = parent_node.get_path()
	
	# Save animation state for visual persistence
	var anim_player = node.get_node_or_null("AnimationPlayer")
	if anim_player and anim_player is AnimationPlayer:
		animation_name = anim_player.current_animation
		animation_position = anim_player.current_animation_position
	
	# Save blend position for AnimationTree (8-direction movement)
	var anim_tree = node.get_node_or_null("AnimationTree")
	if anim_tree and anim_tree is AnimationTree:
		# Try to get Idle blend position (adjust path to match your AnimationTree structure)
		if anim_tree.has("parameters/Idle/blend_position"):
			blend_position = anim_tree.get("parameters/Idle/blend_position")
		elif anim_tree.has("parameters/idle/blend_position"):
			blend_position = anim_tree.get("parameters/idle/blend_position")


func _load_data(window: Window) -> void:
	var scene_node = window.get_node_or_null(node_path)
	
	if scene_node and scene_node is Node2D:
		scene_node.global_position = global_position
		
		# Restore animation state
		if animation_name != "":
			var anim_player = scene_node.get_node_or_null("AnimationPlayer")
			if anim_player and anim_player is AnimationPlayer:
				anim_player.play(animation_name)
				if animation_position > 0:
					anim_player.seek(animation_position, true)
		
		# Restore blend position (facing direction)
		if blend_position != Vector2.ZERO:
			var anim_tree = scene_node.get_node_or_null("AnimationTree")
			if anim_tree and anim_tree is AnimationTree:
				# Set the blend position to restore facing direction
				if anim_tree.has("parameters/Idle/blend_position"):
					anim_tree.set("parameters/Idle/blend_position", blend_position)
				elif anim_tree.has("parameters/idle/blend_position"):
					anim_tree.set("parameters/idle/blend_position", blend_position)
