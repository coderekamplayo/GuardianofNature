class_name GameInputEvents

# We no longer need the static 'direction' variable.

# This function now correctly handles held keys and returns a normalized vector.
static func movement_input() -> Vector2:
	return Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")

# This function now correctly checks if any movement key is being held.
static func is_movement_input() -> bool:
	return movement_input() != Vector2.ZERO
