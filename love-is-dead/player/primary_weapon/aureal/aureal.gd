class_name Aureal
extends PrimaryWeapon

var _lifetime: float = 0.0
var _fired: bool = false

@onready var hitbox: Area2D = $Hitbox


func _init() -> void:
	cooldown = 1.0
	max_lifetime = 3.0
	speed = 1000.0
	gravity_scale = 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	hitbox.body_entered.connect(_on_enemy_entered)


func _physics_process(delta: float) -> void:
	_lifetime += delta
	if _lifetime >= max_lifetime:
		queue_free()
		return
	if linear_velocity.length_squared() > 1.0:
		rotation = linear_velocity.angle()


func try_fire(direction: Vector2) -> bool:
	if _fired:
		return _fired
	_fired = true

	rotation = direction.angle()
	apply_central_impulse(direction * speed * mass)
	return _fired


func _on_body_entered(_body: Node2D) -> void:
	queue_free()


func _on_enemy_entered(_body: Node2D) -> void:
	if _body != null:
		_body.take_damage(base_damage)
		queue_free()
