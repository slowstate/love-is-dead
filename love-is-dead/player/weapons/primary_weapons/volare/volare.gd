class_name Volare
extends Weapon

const VOLARE_ARROW = preload("uid://bcfm8c5gces34")

var _max_lifetime: float = 3.0
var _lifetime: float = 0.0
var _speed: float = 1000.0
var _base_damage: float = 20.0
var _arrow_count: int = 3
var _spread_angle: float = PI / 12.0


func _init() -> void:
	cooldown = 1.0


func fire() -> void:
	var base_direction: Vector2 = (get_global_mouse_position() - GlobalInstances.player.global_position).normalized()
	for i in _arrow_count:
		var t: float = float(i) / float(_arrow_count - 1) - 0.5 # -0.5 to 0.5
		var arrow: VolareArrow = VOLARE_ARROW.instantiate()
		var angle_offset: float = t * _spread_angle * 2.0
		arrow.direction = base_direction.rotated(angle_offset)
		arrow.rotation = arrow.direction.angle()
		arrow.global_position = GlobalInstances.player.global_position
		arrow.max_lifetime = _max_lifetime
		arrow.lifetime = _lifetime
		arrow.speed = _speed
		arrow.damage = _base_damage
		arrow.gravity_scale = 0.0
		Engine.get_main_loop().current_scene.add_child(arrow)
		arrow.fire()
