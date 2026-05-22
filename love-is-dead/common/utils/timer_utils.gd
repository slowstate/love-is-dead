class_name TimerUtils


static func timer_progress(timer: Timer) -> float:
	return 1.0 - timer.time_left / timer.wait_time
