class_name RangedMinion
extends Enemy

const RANGED_MINION = preload("uid://duj6v1s1xsheh")
const RANGED_MINION_PROJECTILE = preload("uid://dxlvvvx0vrwk3")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var flee_detector: Area2D = $Pivot/FleeDetector
@onready var attack_detector: RayCast2D = $Pivot/AttackDetector
@onready var turn_around_detector: RayCast2D = $Pivot/TurnAroundDetector
@onready var projectile_origin: Marker2D = $Pivot/ProjectileOrigin


static func create(_initial_position: Vector2) -> RangedMinion:
	var new_enemy: RangedMinion = RANGED_MINION.instantiate()
	new_enemy.global_position = _initial_position
	new_enemy.speed = 50.0
	new_enemy.max_health = 100.0
	return new_enemy


func _fire_projectile() -> void:
	var new_projectile: RangedMinionProjectile = RANGED_MINION_PROJECTILE.instantiate()
	var direction: Vector2 = Vector2(pivot.scale.x, 0.0)
	new_projectile.rotation = direction.angle()
	new_projectile.global_position = projectile_origin.global_position
	Engine.get_main_loop().current_scene.add_child(new_projectile)
	new_projectile.fire(direction)
