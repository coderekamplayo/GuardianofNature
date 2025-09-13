extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 50

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()
	
	# Play animations based on direction
	if direction.y < 0:
		animated_sprite_2d.play("walk_back")
	elif direction.x > 0:
		animated_sprite_2d.play("walk_right")
	elif direction.y > 0:
		animated_sprite_2d.play("walk_front")
	elif direction.x < 0:
		animated_sprite_2d.play("walk_left")
	
	# Update the player's facing direction if they are moving
	if direction != Vector2.ZERO:
		player.player_direction = direction
	
	player.velocity = direction * speed
	player.move_and_slide()

func _on_next_transitions() -> void:
	# --- THIS IS THE FIX ---
	# Now that our input script works, this logic is correct.
	# We transition to Idle if the player is NOT moving.
	if not GameInputEvents.is_movement_input():
		transition.emit("Idle")


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite_2d.stop()
