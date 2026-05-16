class_name Needler
extends Weapon

const NEEDLER_ARROW = preload("uid://cjqcpymnnt5lc")


func _init() -> void:
	cooldown = 0.5


func fire(direction: Vector2) -> void:
	var arrow: NeedlerArrow = NEEDLER_ARROW.instantiate()
	arrow.rotation = direction.angle()
	arrow.global_position = GlobalInstances.player.global_position
	Engine.get_main_loop().current_scene.add_child(arrow)
	arrow.fire(direction)
