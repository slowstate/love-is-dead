class_name SpearOfMars
extends Weapon

var _base_damage: float = 50.0

@onready var low_floor_detector_ray: RayCast2D = $LowFloorDetectorRay
@onready var mid_floor_detector_ray: RayCast2D = $MidFloorDetectorRay
@onready var high_floor_detector_ray: RayCast2D = $HighFloorDetectorRay
@onready var lighting_animation: AnimatedSprite2D = $LightingAnimation
@onready var large_impact_animation: AnimatedSprite2D = $LargeImpactAnimation
@onready var small_impact_animation: AnimatedSprite2D = $SmallImpactAnimation
@onready var explosion_area: Area2D = $ExplosionArea


func _init() -> void:
	cooldown = 5.0


func fire() -> void:
	lighting_animation.play("lightning")
	# Force the ray to check for collisions immediately
	var raycasts: Array[RayCast2D] = [low_floor_detector_ray, mid_floor_detector_ray, high_floor_detector_ray]
	for ray in raycasts:
		ray.force_raycast_update()
		if ray.is_colliding():
			global_position.y = ray.get_collision_point().y - 30
			return


func _on_body_entered(_body: Node) -> void:
	large_impact_animation.play("impact")
	small_impact_animation.play("impact")
	var enemies: Array[Enemy] = []
	enemies.assign(explosion_area.get_overlapping_bodies().filter(func(b): return b is Enemy))
	for enemy in enemies:
		enemy.take_damage(_base_damage)

	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1.0, 1.0, 1.0, 0.0), 5.0)
	await get_tree().create_timer(5.0).timeout
	queue_free()
