class_name MinionRoamState
extends State

var minion: Minion

@onready var timer: Timer = $Timer


func enter() -> void:
	minion = owner as Minion

	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	timer.start(randf_range(1.0, 3.0))
	var chase_direction = [1, -1].pick_random()
	minion._set_facing_right(true if chase_direction == 1 else false)
	var roam_speed_multiplier = randf_range(0.2, 0.5)
	minion.velocity.x = chase_direction * minion.speed * roam_speed_multiplier
	minion.animated_sprite.play("walk", roam_speed_multiplier)


func exit() -> void:
	minion.animated_sprite.stop()
	minion.velocity.x = 0
	timer.stop()


func update(_delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	minion._apply_gravity(delta)
	if minion.chase_detector.has_overlapping_areas():
		transition.emit("Chase")
		return
	minion.move_and_slide()


func _on_timer_timeout() -> void:
	transition.emit("Idle")
