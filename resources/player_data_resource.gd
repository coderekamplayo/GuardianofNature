class_name PlayerDataResource
extends NodeDataResource

# Animation state
@export var current_animation: String = ""
@export var animation_frame: int = 0
@export var animation_progress: float = 0.0

# Direction/Visual state
@export var flip_h: bool = false
@export var flip_v: bool = false
@export var rotation_degrees: float = 0.0
# RENAMED to avoid conflict with parent class
@export var animation_blend_position: Vector2 = Vector2.ZERO  # For AnimationTree blend spaces

func _save_data(node: Node2D) -> void:
	# Save position and paths from parent
	super._save_data(node)
	
	# Save animation state
	var animated_sprite: AnimatedSprite2D = node.get_node_or_null("AnimatedSprite2D")
	if animated_sprite:
		current_animation = animated_sprite.animation
		animation_frame = animated_sprite.frame
		animation_progress = 0.0
	
	var anim_player: AnimationPlayer = node.get_node_or_null("AnimationPlayer")
	if anim_player:
		current_animation = anim_player.current_animation
		animation_progress = anim_player.current_animation_position
	
	# Save AnimationTree blend position
	var anim_tree: AnimationTree = node.get_node_or_null("AnimationTree")
	if anim_tree:
		# Use the renamed variable
		animation_blend_position = anim_tree.get("parameters/conditions/idle_blend") or Vector2.ZERO
	
	# Save visual direction
	var sprite: Sprite2D = node.get_node_or_null("Sprite2D")
	if sprite:
		flip_h = sprite.flip_h
		flip_v = sprite.flip_v
		rotation_degrees = sprite.rotation_degrees

func _load_data(_window: Window) -> void:
	# Get the node
	var node: Node2D = _window.get_node_or_null(node_path)
	if not node:
		print("ERROR: Could not find node at path: ", node_path)
		return
	
	# Restore position
	node.global_position = global_position
	
	# Restore animation state
	var animated_sprite: AnimatedSprite2D = node.get_node_or_null("AnimatedSprite2D")
	if animated_sprite and current_animation:
		if animated_sprite.has_animation(current_animation):
			animated_sprite.animation = current_animation
		animated_sprite.frame = animation_frame
		animated_sprite.flip_h = flip_h
		animated_sprite.flip_v = flip_v
		animated_sprite.queue_redraw()
	
	var anim_player: AnimationPlayer = node.get_node_or_null("AnimationPlayer")
	if anim_player and current_animation:
		if anim_player.has_animation(current_animation):
			anim_player.play(current_animation)
			anim_player.seek(animation_progress)
	
	# Restore AnimationTree with renamed variable
	var anim_tree: AnimationTree = node.get_node_or_null("AnimationTree")
	if anim_tree:
		anim_tree.set("parameters/conditions/idle_blend", animation_blend_position)
		anim_tree.advance(0)
	
	# Restore visual state
	var sprite: Sprite2D = node.get_node_or_null("Sprite2D")
	if sprite:
		sprite.flip_h = flip_h
		sprite.flip_v = flip_v
		sprite.rotation_degrees = rotation_degrees
	
	# Force update
	node.queue_redraw()
