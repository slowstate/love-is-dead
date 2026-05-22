class_name RangedMinionFleeState
extends State

var ranged_minion: RangedMinion


func enter() -> void:
	ranged_minion = owner as RangedMinion
	ranged_minion.animation_player.play("walk")


func exit() -> void:
	ranged_minion.animation_player.stop()


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if !ranged_minion.flee_detector.has_overlapping_areas():
		transition.emit("Roam")
	else:
		ranged_minion._apply_gravity(delta)
		var flee_direction = 1 if (ranged_minion.global_position.x - GlobalInstances.player.global_position.x) > 0 else -1
		ranged_minion._set_facing_right(true if flee_direction == 1 else false)
		ranged_minion.velocity.x = flee_direction * ranged_minion.speed
		ranged_minion.move_and_slide()
