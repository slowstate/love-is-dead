class_name SpearOfMars
extends Weapon

const SPEAR_OF_MARS_SPEAR = preload("uid://v1iadtyxf6h4")

var _base_damage: float = 100.0


func _init() -> void:
	cooldown = 5.0


func fire() -> void:
	var spear: SpearOfMarsSpear = SPEAR_OF_MARS_SPEAR.instantiate()
	spear.global_position = get_global_mouse_position()
	spear.damage = _base_damage
	Engine.get_main_loop().current_scene.add_child(spear)
	spear.fire()
