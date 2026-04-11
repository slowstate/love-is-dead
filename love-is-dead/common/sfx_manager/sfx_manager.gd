extends Node


func play_sfx(
	sfx_stream_string: String,
	time_delay: float = 0.0,
	volume_db_min: float = 0.0,
	volume_db_max: float = 0.0,
	pitch_scale_min: float = 1.0,
	pitch_scale_max: float = 1.0):
	
	stop_sfx(sfx_stream_string)
	
	#Creates a delay timer
	if time_delay > 0:
		await get_tree().create_timer(time_delay).timeout

	#Checks if file exists
	var sfx_type = get_node_or_null(sfx_stream_string)
	if sfx_type == null:
		print(sfx_stream_string+" not found")
		return

	#Plays random sound
	var sfx_index = randi_range(0,sfx_type.get_child_count()-1)
	var sfx_stream = sfx_type.get_child(sfx_index)
	sfx_stream.volume_db = randf_range(volume_db_min, volume_db_max)
	sfx_stream.pitch_scale = randf_range(pitch_scale_min, pitch_scale_max)
	sfx_stream.play()


func play_continuous_sfx(
	sfx_stream_string: String,
	time_delay: float = 0.0,
	volume_db_min: float = 0.0,
	volume_db_max: float = 0.0,
	pitch_scale_min: float = 1.0,
	pitch_scale_max: float = 1.0):
	
	#Creates a delay timer
	if time_delay > 0:
		await get_tree().create_timer(time_delay).timeout
		
	#Checks if file exists
	var sfx_type = get_node_or_null(sfx_stream_string)
	if sfx_type == null:
		print(sfx_stream_string+" not found")
		return
	
	#Checks if same type of sound is already playing
	for child in sfx_type.get_children():
		if child is AudioStreamPlayer:
			if child.is_playing():
				return
	
	#Plays random sound
	var sfx_index = randi_range(0,sfx_type.get_child_count()-1)
	var sfx_stream = sfx_type.get_child(sfx_index)
	sfx_stream.volume_db = randf_range(volume_db_min, volume_db_max)
	sfx_stream.pitch_scale = randf_range(pitch_scale_min, pitch_scale_max)
	sfx_stream.play()


func play_ambience_sfx(
	sfx_stream_string: String,
	time_delay: float = 0.0,
	volume_db_min: float = 0.0,
	volume_db_max: float = 0.0,
	pitch_scale_min: float = 1.0,
	pitch_scale_max: float = 1.0):
	var sfx_type = get_node_or_null(sfx_stream_string)
	
	if sfx_type == null:
		print(sfx_stream_string+" not found")
		return
	
	var sfx_index = randi_range(0,sfx_type.get_child_count()-1)
	var sfx_stream = sfx_type.get_child(sfx_index)
	sfx_stream.volume_db = randf_range(volume_db_min, volume_db_max)
	sfx_stream.pitch_scale = randf_range(pitch_scale_min, pitch_scale_max)
	sfx_stream.play()
	
	await get_tree().create_timer(sfx_stream.stream.get_length()-0.1).timeout
	if sfx_stream.is_playing() == true:
		if time_delay > 0:
			await get_tree().create_timer(time_delay+sfx_stream.stream.get_length()).timeout
		
		play_ambience_sfx(sfx_stream_string, time_delay, volume_db_min, volume_db_max, pitch_scale_min, pitch_scale_max)


func fade_sfx(
	sfx_stream_string: String,
	timer_delay: float = 0.0,
	fade_duration: float = 0.0):
	await get_tree().create_timer(timer_delay).timeout
	
	var sfx_type = get_node_or_null(sfx_stream_string)
	if sfx_type == null:
		print(sfx_stream_string+" not found")
		return
	
	for child in sfx_type.get_children():
		if child is AudioStreamPlayer:
			if child.is_playing():
				var sfx_fade_tween = create_tween()
				sfx_fade_tween.tween_property(child,"volume_db",-80,fade_duration)
				
				await get_tree().create_timer(fade_duration).timeout
				stop_sfx(sfx_stream_string)


func stop_sfx(sfx_stream_string: String):
	var sfx_type = get_node_or_null(sfx_stream_string)
	if sfx_type == null:
		print(sfx_stream_string+" not found")
		return
	
	for child in sfx_type.get_children():
		if child is AudioStreamPlayer:
			if child.is_playing():
				child.stop()


func stop_all_sfx():
	for sfx_type in SfxManager.get_children():
		for child in sfx_type.get_children():
			if child is AudioStreamPlayer:
				if child.is_playing():
					child.stop()
