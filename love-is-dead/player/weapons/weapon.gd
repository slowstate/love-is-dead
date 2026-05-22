class_name Weapon
extends Node2D

var cooldown: float = 0.0
var _cooldown_remaining: float = 0.0


func _process(delta: float) -> void:
	if _cooldown_remaining > 0.0:
		_cooldown_remaining -= min(delta, _cooldown_remaining)
		return


func try_fire(direction: Vector2) -> bool:
	if _cooldown_remaining <= 0.0:
		_cooldown_remaining = cooldown
		fire(direction)
		return true
	else:
		return false


func fire(_direction: Vector2) -> void:
	return
