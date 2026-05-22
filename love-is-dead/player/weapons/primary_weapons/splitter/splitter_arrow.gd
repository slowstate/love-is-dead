class_name SplitterArrow
extends RigidBody2D

const SPLITTER_BOLT = preload("uid://ni30o2mikxtr")

var lifetime: float = 1.5
var speed: float = 1000.0
var damage: float = 20.0
var _lifetime_elapsed: float = 0.0
var _has_hit: bool = false

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
	if enemy != null and enemy is Enemy and !_has_hit:
		_has_hit = true
		enemy.take_damage(damage)
		_spawn_bolts(2)
		queue_free()


func _spawn_bolts(amount: int) -> void:
	for i in amount:
		var bolt = SPLITTER_BOLT.instantiate()
		bolt.rotation = randf() * 2 * PI
		bolt.global_position = global_position
		get_tree().root.call_deferred("add_child", bolt)
		bolt.fire(Vector2.from_angle(bolt.rotation))
