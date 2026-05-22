class_name Minion
extends Enemy

const MINION = preload("uid://uyc02gsgp57j")

@onready var state_machine: StateMachine = $StateMachine
@onready var chase_detector: Area2D = $Pivot/ChaseDetector
@onready var attack_detector: Area2D = $Pivot/AttackDetector
@onready var attack_hitbox: Area2D = $Pivot/AttackHitbox
@onready var pivot: Node2D = $Pivot


static func create(_initial_position: Vector2) -> Minion:
	var new_enemy: Minion = MINION.instantiate()
	new_enemy.global_position = _initial_position
	new_enemy.speed = 50.0
	new_enemy.max_health = 200.0
	return new_enemy


func _set_facing_right(is_facing_right: bool) -> void:
	pivot.scale.x = 1 if is_facing_right else -1
