class_name Quiver
extends Weapon


func _init() -> void:
	cooldown = 1.0


func fire(_direction: Vector2) -> void:
	var bolts = get_tree().get_nodes_in_group(GlobalConstants.SPLITTER_BOLTS) as Array[SplitterBolt]
	for bolt in bolts:
		bolt.return_to_player()
