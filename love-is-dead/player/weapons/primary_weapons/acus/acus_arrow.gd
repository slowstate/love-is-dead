class_name AcusArrow
extends RigidBody2D

const NEEDLES = preload("uid://dthqexgwdeomi")

var lifetime: float = 1.0
var speed: float = 1000.0
var damage: float = 20.0
var _lifetime_elapsed: float = 0.0

@onready var hitbox: Area2D = $Hitbox


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	hitbox.area_entered.connect(_on_enemy_entered)


func _physics_process(delta: float) -> void:
	_lifetime_elapsed += delta
	if _lifetime_elapsed >= lifetime:
		queue_free()
		return


func fire(direction: Vector2) -> void:
	apply_central_impulse(direction * speed * mass)


func _on_body_entered(_body: Node2D) -> void:
	queue_free()


func _on_enemy_entered(enemy_hurtbox: Area2D) -> void:
	var enemy = enemy_hurtbox.owner as Enemy
	if enemy != null and enemy is Enemy:
		enemy.take_damage(damage)
		_apply_needles(enemy)
		queue_free()


func _apply_needles(enemy: Enemy) -> void:
	var needles: Needles
	if !ComponentUtils.has_component(enemy, Needles.string_name):
		needles = NEEDLES.instantiate()
		enemy.add_child(needles)
	needles = ComponentUtils.get_component(enemy, Needles.string_name)
	needles.add_needles(1)
