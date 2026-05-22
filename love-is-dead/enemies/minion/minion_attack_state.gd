class_name MinionAttackState
extends State

var minion: Minion


func enter() -> void:
	minion = owner as Minion
	if minion.velocity.x <= minion.speed:
		minion.velocity.x = 0.0
	minion.animation_player.play("attack")
	if !minion.animation_player.animation_finished.is_connected(_on_animation_player_animation_finished):
		minion.animation_player.animation_finished.connect(_on_animation_player_animation_finished)


func exit() -> void:
	minion.animation_player.stop()


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	minion._apply_gravity(delta)
	minion.move_and_slide()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if minion.attack_detector.has_overlapping_areas():
		transition.emit("Attack")
	elif minion.chase_detector.has_overlapping_areas():
		transition.emit("Chase")
	else:
		transition.emit("Roam")
