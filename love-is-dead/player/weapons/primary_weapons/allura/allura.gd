class_name Allura
extends Weapon

const ALLURE = preload("uid://cjtjr7gfdpikv")

var _max_lifetime: float = 3.0
var _lifetime: float = 0.0
var _speed: float = 1000.0
var _base_damage: float = 20.0

@onready var hitbox: Area2D = $Hitbox


func _init() -> void:
	cooldown = 0.5
	gravity_scale = 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	hitbox.body_entered.connect(_on_enemy_entered)


func _physics_process(delta: float) -> void:
	_lifetime += delta
	if _lifetime >= _max_lifetime:
		queue_free()
		return
	if linear_velocity.length_squared() > 1.0:
		rotation = linear_velocity.angle()


func fire() -> void:
	var direction: Vector2 = (get_global_mouse_position() - GlobalInstances.player.global_position).normalized()
	rotation = direction.angle()
	apply_central_impulse(direction * _speed * mass)
	return


func _on_body_entered(_body: Node2D) -> void:
	queue_free()


func _on_enemy_entered(body: Node2D) -> void:
	if body != null and body is Enemy:
		body.take_damage(_base_damage)
		_apply_allure(body)
		queue_free()


func _apply_allure(body: Enemy) -> void:
	var allure: Allure
	if !ComponentUtils.has_component(body, Allure.string_name):
		allure = ALLURE.instantiate()
		body.call_deferred("add_child", allure)
		await allure.ready
	else:
		allure = ComponentUtils.get_component(body, Allure.string_name)
	allure.add_allure_and_restart_timer(1)
