extends Button


func _on_pressed() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
