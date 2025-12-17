class_name NodeDataResource
extends Resource

@export var global_position: Vector2
@export var node_path: NodePath
@export var parent_node_path: NodePath

@export var animation_name: String = ""
@export var animation_position: float = 0.0
@export var blend_position: Vector2 = Vector2.ZERO

# [FIX] Add a specific property for the player's facing direction variable
@export var player_direction: Vector2 = Vector2.ZERO

func _save_data(node: Node2D) -> void:
	global_position = node.global_position
	node_path = node.get_path()
	
	var parent_node = node.get_parent()
	if parent_node != null:
		parent_node_path = parent_node.get_path()
	
	# [FIX] Save the 'player_direction' variable if the script has it
	if "player_direction" in node:
		player_direction = node.player_direction
	
	# Save AnimationPlayer state (if used)
	var anim_player = node.get_node_or_null("AnimationPlayer")
	if anim_player and anim_player is AnimationPlayer:
		animation_name = anim_player.current_animation
		animation_position = anim_player.current_animation_position
		
	# Save AnimationTree Blend Position (if used)
	var anim_tree = node.get_node_or_null("AnimationTree")
	if anim_tree and anim_tree is AnimationTree:
		if anim_tree.get("parameters/Idle/blend_position") != null:
			blend_position = anim_tree.get("parameters/Idle/blend_position")
		elif anim_tree.get("parameters/idle/blend_position") != null:
			blend_position = anim_tree.get("parameters/idle/blend_position")

func _load_data(window: Window) -> void:
	var scene_node = window.get_node_or_null(node_path)
	
	if scene_node and scene_node is Node2D:
		scene_node.global_position = global_position
		
		# [FIX] Restore the 'player_direction' variable
		if "player_direction" in scene_node:
			scene_node.player_direction = player_direction
		
		# Restore AnimationPlayer
		if animation_name != "":
			var anim_player = scene_node.get_node_or_null("AnimationPlayer")
			if anim_player and anim_player is AnimationPlayer:
				anim_player.play(animation_name)
				if animation_position > 0.0:
					anim_player.seek(animation_position, true)
		
		# Restore AnimationTree
		if blend_position != Vector2.ZERO:
			var anim_tree = scene_node.get_node_or_null("AnimationTree")
			if anim_tree and anim_tree is AnimationTree:
				if anim_tree.get("parameters/Idle/blend_position") != null:
					anim_tree.set("parameters/Idle/blend_position", blend_position)
				elif anim_tree.get("parameters/idle/blend_position") != null:
					anim_tree.set("parameters/idle/blend_position", blend_position)
