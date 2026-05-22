class_name RangedMinionIdleState
extends State

var ranged_minion: RangedMinion

@onready var timer: Timer = $Timer


func enter() -> void:
	ranged_minion = owner as RangedMinion

	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	timer.start(randf_range(1.0, 2.0))
	ranged_minion.velocity.x = 0
	ranged_minion.animation_player.play("idle")


func exit() -> void:
	ranged_minion.animation_player.stop()
	timer.stop()


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	if ranged_minion.flee_detector.has_overlapping_areas():
		transition.emit("Flee")
	elif ranged_minion.attack_detector.is_colliding() and ranged_minion.attack_detector.get_collider() is Player:
		transition.emit("Attack")
	elif ranged_minion.turn_around_detector.is_colliding() and ranged_minion.turn_around_detector.get_collider() is Player:
		ranged_minion._flip_facing_direction()
	else:
		ranged_minion._apply_gravity(delta)
		ranged_minion.move_and_slide()


func _on_timer_timeout() -> void:
	transition.emit("Roam")
