class_name SplitterBolt
extends RigidBody2D

var lifetime: float = 20.0
var speed: float = 800.0
var return_speed: float = 1200.0
var damage: float = 10.0
var _lifetime_elapsed: float = 0.0
var _returning: bool = false

@onready var hitbox: Area2D = $Hitbox


func _ready() -> void:
	add_to_group(GlobalConstants.SPLITTER_BOLTS)
	body_entered.connect(_on_body_entered)
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	hitbox.body_entered.connect(_on_hitbox_body_entered)


func _physics_process(delta: float) -> void:
	if _returning:
		var vector_to_player: Vector2 = (GlobalInstances.player.global_position - global_position).normalized()
		rotation = vector_to_player.angle()
		linear_velocity = vector_to_player * return_speed
		return
	_lifetime_elapsed += delta
	if _lifetime_elapsed >= lifetime:
		queue_free()
		return


func fire(direction: Vector2) -> void:
	apply_central_impulse(direction * speed * mass)


func return_to_player() -> void:
	hitbox.monitoring = true
	hitbox.monitorable = true
	_returning = true
	set_collision_mask_value(1, false)


func _on_body_entered(_body: Node2D) -> void:
	linear_velocity = Vector2.ZERO


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.owner is Enemy:
		var enemy = area.owner as Enemy
		if enemy != null and enemy is Enemy:
			enemy.take_damage(damage)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player and _returning:
		queue_free()
