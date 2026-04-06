class_name PrimaryWeapon
extends RigidBody2D

enum Type {
	Aureal,
}

var cooldown: float = 0.0
var speed: float = 0.0
var max_lifetime: float = 0.0
var base_damage: float = 20.0


func try_fire(_direction: Vector2) -> bool:
	return false
