extends Button

@export var enemy_scene: PackedScene

@onready var collision_shape_2d: CollisionShape2D = $"../../Stage/Enemy_Spawn_Zone/CollisionShape2D"
@onready var enemy_list: Node2D = $"../../Stage/EnemyList"


func _on_pressed() -> void:
	var spawn_area: Vector2 = collision_shape_2d.shape.extents
	var spawn_location = Vector2(randf_range(-spawn_area.x, spawn_area.x), randf_range(-spawn_area.y, spawn_area.y)) + collision_shape_2d.global_position
	var enemy_to_spawn = Minion.create(spawn_location)
	enemy_list.add_child(enemy_to_spawn)
