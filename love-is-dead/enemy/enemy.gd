class_name Enemy
extends CharacterBody2D

signal died(enemy: Enemy)

# --- External Parameters -----------------------------------------------------
@export var speed: float = 100.0
@export var max_health: float = 200.0
@export var sprite: Sprite2D
@export var collision_box: CollisionShape2D
@export var hurtbox: Area2D

var current_health: float
var health_bar_template = preload("res://enemy/enemy_ui/enemy_health_bar.tscn")
var health_bar: ProgressBar
var target: Node2D


# --- Internal Parameters -----------------------------------------------------
func _ready() -> void:
	if GlobalInstances.player:
		target = GlobalInstances.player
	add_to_group("Enemies")
	current_health = max_health
	generate_ui()


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	chase_on_ground(delta)

	move_and_slide()


func chase_on_ground(_delta: float):
	if !target:
		return

	var chase_direction = sign(target.global_position.x - global_position.x)
	velocity.x = chase_direction * speed


func take_damage(damage: float):
	if damage >= 0.0:
		current_health -= damage
		update_health_bar()
		if current_health <= 0:
			current_health = 0
			died.emit(self)
			queue_free()


func update_health_bar():
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar.global_position = self.global_position + Vector2(0, -30) - health_bar.size / 2


func generate_ui():
	health_bar = health_bar_template.instantiate()
	add_child(health_bar)
	update_health_bar()


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GlobalConstants.gravity * delta
