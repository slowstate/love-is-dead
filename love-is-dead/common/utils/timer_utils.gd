class_name TimerUtils
extends Node


static func timer_progress(timer: Timer) -> float:
	return 1.0 - timer.time_left / timer.wait_time
