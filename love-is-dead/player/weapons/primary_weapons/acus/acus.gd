class_name Acus
extends Weapon

const ACUS_ARROW = preload("uid://cjqcpymnnt5lc")

var _lifetime: float = 3.0
var _speed: float = 1000.0
var _damage: float = 20.0


func _init() -> void:
	cooldown = 0.5


func fire(direction: Vector2) -> void:
	var arrow: AcusArrow = ACUS_ARROW.instantiate()
	arrow.rotation = direction.angle()
	arrow.global_position = GlobalInstances.player.global_position
	arrow.lifetime = _lifetime
	arrow.speed = _speed
	arrow.damage = _damage
	arrow.gravity_scale = 0.0
	Engine.get_main_loop().current_scene.add_child(arrow)
	arrow.fire(direction)
