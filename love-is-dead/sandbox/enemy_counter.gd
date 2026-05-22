extends Label


func _process(_delta: float) -> void:
	text = "Enemies: " + str(get_tree().get_nodes_in_group("enemies").size())
