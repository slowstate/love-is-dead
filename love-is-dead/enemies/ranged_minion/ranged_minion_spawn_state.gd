class_name RangedMinionSpawnState
extends State

var ranged_minion: RangedMinion

@onready var timer: Timer = $Timer


func enter() -> void:
	ranged_minion = owner as RangedMinion

	if !timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	timer.start(1)


func exit() -> void:
	ranged_minion.hurtbox.monitorable = true
	ranged_minion.flee_detector.monitoring = true
	ranged_minion.attack_detector.enabled = true
	ranged_minion.turn_around_detector.enabled = true
	timer.stop()


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	ranged_minion.modulate = lerp(Color(38, 38, 38, 0), Color(1, 1, 1, 1), 1 - timer.time_left / timer.wait_time)


func _on_timer_timeout() -> void:
	ranged_minion.modulate = Color(1, 1, 1, 1)
	transition.emit("Roam")
