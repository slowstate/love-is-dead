class_name Allura
extends Weapon

const ALLURA_ARROW = preload("uid://dwbtboe4r72fg")

var _max_lifetime: float = 3.0
var _lifetime: float = 0.0
var _speed: float = 1000.0
var _base_damage: float = 20.0


func _init() -> void:
	cooldown = 0.5


func fire() -> void:
	var arrow: AlluraArrow = ALLURA_ARROW.instantiate()
	arrow.direction = (get_global_mouse_position() - GlobalInstances.player.global_position).normalized()
	arrow.rotation = arrow.direction.angle()
	arrow.global_position = GlobalInstances.player.global_position
	arrow.max_lifetime = _max_lifetime
	arrow.lifetime = _lifetime
	arrow.speed = _speed
	arrow.damage = _base_damage
	arrow.gravity_scale = 0.0
	Engine.get_main_loop().current_scene.add_child(arrow)
	arrow.fire()
