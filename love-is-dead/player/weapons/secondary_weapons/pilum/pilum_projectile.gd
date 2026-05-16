class_name PilumProjectile
extends RigidBody2D

@warning_ignore("unused_signal")
signal enemy_killed

const NEEDLES = preload("uid://dthqexgwdeomi")

var lifetime: float = 1.5
var speed: float = 2000.0
var damage: float = 20.0
var _lifetime_elapsed: float = 0.0
var _needles_carried: int = 0
var _has_hit: bool = false

@onready var hitbox: Area2D = $Hitbox


func _ready() -> void:
	body_entered.connect(_on_terrain_entered)
	hitbox.area_entered.connect(_on_enemy_entered)


func _physics_process(delta: float) -> void:
	_lifetime_elapsed += delta
	if _lifetime_elapsed >= lifetime:
		queue_free()
		return


func fire(direction: Vector2) -> void:
	apply_central_impulse(direction * speed * mass)


func _on_terrain_entered(_body: Node2D) -> void:
	hitbox.set_deferred("monitoring", false)
	hitbox.set_deferred("monitorable", false)
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1.0, 1.0, 1.0, 0.0), 2.0)
	await get_tree().create_timer(2.0).timeout
	queue_free()


func _on_enemy_entered(enemy_hurtbox: Area2D) -> void:
	var enemy = enemy_hurtbox.owner as Enemy
	if enemy != null and enemy is Enemy and !_has_hit:
		_has_hit = true
		if !ComponentUtils.has_component(enemy, Needles.string_name) and _needles_carried > 0:
			var needles = NEEDLES.instantiate()
			enemy.add_child(needles)
		if ComponentUtils.has_component(enemy, Needles.string_name):
			var needles = ComponentUtils.get_component(enemy, Needles.string_name) as Needles
			needles.needle_amount += _needles_carried
			_needles_carried = needles.needle_amount
			needles.trigger_needles()
		enemy.take_damage(damage)
		if !enemy or enemy.current_health <= 0.0: # If enemy died, pilum penetrates
			_has_hit = false
			return
		queue_free()
