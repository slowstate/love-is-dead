class_name RangedMinionAttackState
extends State

var ranged_minion: RangedMinion


func enter() -> void:
	ranged_minion = owner as RangedMinion
	if ranged_minion.velocity.x <= ranged_minion.speed:
		ranged_minion.velocity.x = 0.0
	ranged_minion.animation_player.play("attack")
	if !ranged_minion.animation_player.animation_finished.is_connected(_on_animation_player_animation_finished):
		ranged_minion.animation_player.animation_finished.connect(_on_animation_player_animation_finished)


func exit() -> void:
	ranged_minion.animation_player.stop()


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	ranged_minion._apply_gravity(delta)
	ranged_minion.move_and_slide()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if ranged_minion.flee_detector.has_overlapping_areas():
		transition.emit("Flee")
	elif ranged_minion.attack_detector.is_colliding() and ranged_minion.attack_detector.get_collider() is Player:
		transition.emit("Attack")
	else:
		transition.emit("Roam")


func _check_attack_hit() -> void:
	if !ranged_minion.attack_hitbox.has_overlapping_areas():
		return
	GlobalInstances.player.take_damage(10)
