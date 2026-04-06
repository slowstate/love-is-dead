class_name Enemy
extends CharacterBody2D

@export var speed: float = 100.0
@export var max_health: float = 100.0

var current_health: float

var player: CharacterBody2D
var health_bar_template = preload("res://enemy/enemy_ui/enemy_health_bar.tscn")
var health_bar: ProgressBar

func _ready() -> void:
	player = GlobalInstances.player
	add_to_group("Enemies")	
	current_health = max_health
	generate_ui()



func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	chase_on_ground(player, delta)
	
	move_and_slide()

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GlobalConstants.gravity * delta


func select_target(target: CharacterBody2D):
	if target is CharacterBody2D:
		var target_coordinates = Vector2(target.global_position)
		return target_coordinates
	else:
		return global_position


func chase_on_ground(target: CharacterBody2D, delta: float):
	if target != null:
		var chase_direction = sign(select_target(target).x - global_position.x)
		velocity.x = chase_direction * speed


func take_damage(damage: float):
	if damage >= 0.0:
		current_health -= damage
		update_health_bar()
		if current_health <= 0:
			current_health = 0
			queue_free()


func update_health_bar():
	health_bar.value = current_health
	health_bar.global_position = self.global_position + Vector2(0, -30) - health_bar.size / 2 


func generate_ui():
	health_bar = health_bar_template.instantiate()
	add_child(health_bar)
	update_health_bar()
