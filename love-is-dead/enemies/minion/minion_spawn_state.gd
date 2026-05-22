class_name MinionSpawnState
extends State

var minion: Minion

@onready var timer: Timer = $Timer


func enter() -> void:
	minion = owner as Minion

	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	timer.start(1)


func exit() -> void:
	minion.hurtbox.monitorable = true
	minion.chase_detector.monitoring = true
	minion.attack_detector.monitoring = true
	timer.stop()


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	minion.modulate = lerp(Color(38, 38, 38, 0), Color(1, 1, 1, 1), 1 - timer.time_left / timer.wait_time)


func _on_timer_timeout() -> void:
	minion.modulate = Color(1, 1, 1, 1)
	transition.emit("Roam")
