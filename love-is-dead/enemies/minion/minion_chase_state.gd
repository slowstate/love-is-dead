class_name MinionChaseState
extends State

var minion: Minion


func enter() -> void:
	minion = owner as Minion
	minion.animation_player.play("walk")


func exit() -> void:
	minion.animation_player.stop()


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if minion.attack_detector.has_overlapping_areas():
		transition.emit("Attack")
	elif !minion.chase_detector.has_overlapping_areas():
		transition.emit("Roam")
	else:
		minion._apply_gravity(delta)
		var chase_direction = -1 if (minion.global_position.x - GlobalInstances.player.global_position.x) > 0 else 1
		minion._set_facing_right(true if chase_direction == 1 else false)
		minion.velocity.x = chase_direction * minion.speed
		minion.move_and_slide()
