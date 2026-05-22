class_name Minion
extends Enemy

const MINION = preload("uid://uyc02gsgp57j")

@onready var state_machine: StateMachine = $StateMachine
@onready var chase_detector: Area2D = $Pivot/ChaseDetector
@onready var attack_detector: Area2D = $Pivot/AttackDetector
@onready var attack_hitbox: Area2D = $Pivot/AttackHitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer


static func create(_initial_position: Vector2) -> Minion:
	var new_enemy: Minion = MINION.instantiate()
	new_enemy.global_position = _initial_position
	new_enemy.speed = 80.0
	new_enemy.max_health = 200.0
	return new_enemy


func _check_attack_hit() -> void:
	if !attack_hitbox.has_overlapping_areas():
		return
	GlobalInstances.player.take_damage(10)
