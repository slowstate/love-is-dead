class_name MinionIdleState
extends State

var minion: Minion

@onready var timer: Timer = $Timer


func enter() -> void:
	minion = owner as Minion

	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	timer.start(randf_range(1.0, 2.0))
	minion.velocity.x = 0
	minion.animated_sprite.play("idle")


func exit() -> void:
	minion.animated_sprite.stop()
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
	transition.emit("Roam")
