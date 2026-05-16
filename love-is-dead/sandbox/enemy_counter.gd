extends Label

@onready var enemy_list: Node2D = $"../../Stage/EnemyList"


func _process(_delta: float) -> void:
	text = "Enemies: " + str(enemy_list.get_child_count())
