class_name MinionAttackState
extends State

var minion: Minion


func enter() -> void:
	minion = owner as Minion
	if minion.velocity.x <= minion.speed:
		minion.velocity.x = 0.0
	minion.animated_sprite.play("attack")
	await get_tree().create_timer(0.5).timeout
	_check_attack_hit()
	await get_tree().create_timer(0.5).timeout
	if minion.attack_detector.has_overlapping_areas():
		transition.emit("Attack")
	if minion.chase_detector.has_overlapping_areas():
		transition.emit("Chase")
	else:
		transition.emit("Roam")


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	minion._apply_gravity(delta)
	minion.move_and_slide()


func _check_attack_hit() -> void:
	if !minion.attack_hitbox.has_overlapping_areas():
		return
	GlobalInstances.player._take_damage(10)
