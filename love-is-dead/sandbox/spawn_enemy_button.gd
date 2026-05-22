extends Button

enum EnemyType {
	MINION,
	RANGED_MINION,
}

@export var enemy_type: EnemyType

@onready var collision_shape_2d: CollisionShape2D = $"../../../../Stage/Enemy_Spawn_Zone/CollisionShape2D"


func _ready() -> void:
	text = "Spawn " + EnemyType.find_key(enemy_type)


func _on_pressed() -> void:
	var spawn_area: Vector2 = collision_shape_2d.shape.extents
	var spawn_location = Vector2(randf_range(-spawn_area.x, spawn_area.x), randf_range(-spawn_area.y, spawn_area.y)) + collision_shape_2d.global_position
	var enemy_to_spawn: Enemy
	match enemy_type:
		EnemyType.MINION:
			enemy_to_spawn = Minion.create(spawn_location)
		EnemyType.RANGED_MINION:
			enemy_to_spawn = RangedMinion.create(spawn_location)
	get_tree().current_scene.add_child(enemy_to_spawn)
