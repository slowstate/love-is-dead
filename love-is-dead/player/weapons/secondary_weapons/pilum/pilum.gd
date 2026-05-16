class_name Pilum
extends Weapon

const PILUM_PROJECTILE = preload("uid://d3dxtifb6060f")


func _init() -> void:
	cooldown = 2.0


func fire(direction: Vector2) -> void:
	var pilum: PilumProjectile = PILUM_PROJECTILE.instantiate()
	pilum.rotation = direction.angle()
	pilum.global_position = GlobalInstances.player.global_position
	pilum.enemy_killed.connect(_on_enemy_killed)
	Engine.get_main_loop().current_scene.add_child(pilum)
	pilum.fire(direction)


func _on_enemy_killed() -> void:
	_cooldown_remaining = 0.0
