extends NodeState

@export var character: NonPlayableCharacter
@export var animated_sprite_2d: AnimatedSprite2D
@export var navigation_agent_2d: NavigationAgent2D
@export var min_speed: float = 5.0
@export var max_speed: float = 10.0

var speed: float

func _ready() -> void:
	navigation_agent_2d.velocity_computed.connect(on_safe_velocity_computed)
	
	call_deferred("character_setup")

func character_setup() -> void:
	await get_tree().physics_frame
		
	set_movement_target()


func set_movement_target() -> void:
	var target_position: Vector2 = NavigationServer2D.map_get_random_point(navigation_agent_2d.get_navigation_map(), navigation_agent_2d.navigation_layers, false)
	print("Target Position: ", target_position)
	navigation_agent_2d.target_position = target_position
	speed = randf_range(min_speed, max_speed)

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		character.current_walk_cycle += 1
		set_movement_target()
		return
	
	# --- CORRECTED LOGIC STARTS HERE ---
	
	# 1. Calculate the desired velocity as you did before.
	var next_position: Vector2 = navigation_agent_2d.get_next_path_position()
	var desired_direction: Vector2 = character.global_position.direction_to(next_position)
	var desired_velocity: Vector2 = desired_direction * speed
	
	# 2. Update the flip direction based on desired velocity.
	# This ensures the character faces the right way even before avoidance adjusts the path.
	if desired_velocity.length_squared() > 0:
		animated_sprite_2d.flip_h = desired_velocity.x < 0
	
	# 3. Handle the two cases: avoidance ON or OFF.
	if navigation_agent_2d.avoidance_enabled:
		# When avoidance is ON, you must "propose" a velocity to the agent.
		# The agent will then do calculations and emit the `velocity_computed` signal
		# with a "safe" velocity.
		navigation_agent_2d.set_velocity(desired_velocity)
	else: 
		# When avoidance is OFF, we move the character directly.
		character.velocity = desired_velocity
		character.move_and_slide()

func on_safe_velocity_computed(safe_velocity: Vector2) -> void:
	print("Safe Velocity: ", safe_velocity)
	animated_sprite_2d.flip_h = safe_velocity.x < 0
	character.velocity = safe_velocity
	character.move_and_slide()

func _on_next_transitions() -> void:
	if character.current_walk_cycle == character.walk_cycles:
		character.velocity = Vector2.ZERO
		transition.emit("Idle")


func _on_enter() -> void:
	animated_sprite_2d.play("walk")
	character.current_walk_cycle = 0
	get_tree().create_timer(randf_range(0.0, 1.0)).timeout.connect(set_movement_target)


func _on_exit() -> void:
	animated_sprite_2d.stop()
