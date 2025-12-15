extends Node2D

var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")

var corn_harvest_scene = preload("res://scenes/objects/plants/corn_harvest.tscn")
var tomato_harvest_scene = preload("res://scenes/objects/plants/tomato_harvest.tscn")

@export var dialogue_start_command: String
@export var food_drop_height: int = 40
@export var reward_output_radius: int = 20
@export var output_reward_scenes: Array[PackedScene] = []

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var feed_component: FeedComponent = $FeedComponent
@onready var reward_marker: Marker2D = $RewardMarker
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool
var is_chest_open: bool

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()
	
	GameDialogueManager.feed_the_animals.connect(on_feed_the_animals)
	feed_component.food_received.connect(on_food_received)

func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true

func on_interactable_deactivated() -> void:
	if is_chest_open:
		animated_sprite_2d.play("chest_close")
	
	is_chest_open = false
	interactable_label_component.hide()
	in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("show_dialogue"):
			interactable_label_component.hide()
			animated_sprite_2d.play("chest_open")
			is_chest_open = true
			
			# create some dialogue
			var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
			get_tree().root.add_child(balloon)
			balloon.start(load("res://dialogue/conversations/chest.dialogue"), dialogue_start_command)

func on_feed_the_animals() -> void:
	if in_range:
		trigger_feed_harvest("corn", corn_harvest_scene)
		trigger_feed_harvest("tomato", tomato_harvest_scene)
		

func trigger_feed_harvest(inventory_item: String, scene: Resource) -> void:
	var inventory: Dictionary = InventoryManager.inventory
	
	if !inventory.has(inventory_item):
		return
	
	var inventory_item_count = inventory[inventory_item]
	
	for index in inventory_item_count:
		var harvest_instance = scene.instantiate() as Node2D
		harvest_instance.global_position = Vector2(global_position.x, global_position.y - food_drop_height)
		get_tree().root.add_child(harvest_instance)
		
		var target_position = global_position
		var tween = get_tree().create_tween()
		
		# Move item into the chest
		tween.tween_property(harvest_instance, "position", target_position, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
		# Shrink it as it enters the chest
		tween.parallel().tween_property(harvest_instance, "scale", Vector2(0, 0), 0.5) 
		# Delete it when done
		tween.tween_callback(harvest_instance.queue_free)
		
		InventoryManager.remove_collectable(inventory_item)
		
		var time_delay = randf_range(0.1, 0.3) 
		await get_tree().create_timer(time_delay).timeout

func on_food_received(_area: Area2D) -> void:
	call_deferred("add_reward_scene")

func add_reward_scene() -> void:
	for scene in output_reward_scenes:
		var reward_scene: Node2D = scene.instantiate()
		get_tree().root.add_child(reward_scene)
		
		# 1. Start the item at the Chest's position
		reward_scene.global_position = global_position
		
		# 2. Calculate the target position on the ground
		var target_position: Vector2 = get_random_position_in_circle(reward_marker.global_position, reward_output_radius)
		
		# 3. Animate the "Jump"
		var tween = get_tree().create_tween()
		tween.set_parallel(true) # Run position and scale tweens at the same time
		
		# Move to the random ground position over 0.5 seconds
		tween.tween_property(reward_scene, "global_position", target_position, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		
		# Optional: Scale it up from tiny to normal size (pop effect)
		reward_scene.scale = Vector2(0, 0)
		tween.tween_property(reward_scene, "scale", Vector2(1, 1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		
		# Small random delay between multiple rewards popping out
		await get_tree().create_timer(randf_range(0.1, 0.3)).timeout

func get_random_position_in_circle(center: Vector2, radius: int) -> Vector2i:
	var angle = randf() * TAU
	
	var distance_from_center = sqrt(randf()) * radius
	
	var x: int = center.x + distance_from_center * cos(angle)
	var y: int = center.y + distance_from_center * sin(angle)
	
	return Vector2i(x, y)
