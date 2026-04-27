class_name Allure
extends Node2D

const CHARMED = preload("uid://bt1lgehxr2tp0")

static var string_name = &"Allure"

var _allure_amount: int = 0
var _allure_duration: float = 3.0
var _alluring_trigger_amount: int = 5
var _alluring_slow_amount: float = 0.5
var _charm_duration: float = 5.0
var _parent: Enemy

@onready var timer: Timer = $Timer
@onready var charm_area_2d: Area2D = $CharmArea2D


func _enter_tree() -> void:
	_parent = get_parent()
	if !_parent:
		queue_free()
	_parent.set_meta(string_name, self)


func _exit_tree() -> void:
	if _parent:
		_parent.remove_meta(string_name)


func add_allure_and_restart_timer(amount: int) -> void:
	if charm_area_2d.monitoring:
		return
	_allure_amount = mini(_allure_amount + amount, _alluring_trigger_amount)
	timer.start(_allure_duration)
	if _allure_amount >= _alluring_trigger_amount:
		_charm_nearby_enemies()
		_parent.speed *= _alluring_slow_amount
		timer.start(_charm_duration)


func _charm_nearby_enemies() -> void:
	charm_area_2d.monitoring = true


# TODO: Do we detect on collision body or hurtbox?
func _on_charm_area_2d_body_entered(body: Node2D) -> void:
	if body and body != _parent and body is Enemy:
		var charmed_component: Charmed = CHARMED.instantiate()
		body.add_child(charmed_component)
		charmed_component.update_target(_parent)


func _on_charm_area_2d_body_exited(body: Node2D) -> void:
	if body and body != _parent and body is Enemy:
		_remove_charmed_component_from_charmed_enemies(body as Enemy)


func _remove_charmed_component_from_charmed_enemies(enemy: Enemy) -> void:
	if !ComponentUtils.has_component(enemy, Charmed.string_name):
		return
	var charmed_component: Charmed = ComponentUtils.get_component(enemy, Charmed.string_name)
	if charmed_component and charmed_component.get_target() == _parent:
		charmed_component.queue_free()


func _on_timer_timeout() -> void:
	if charm_area_2d.monitoring:
		var enemies: Array[Enemy] = []
		enemies.assign(charm_area_2d.get_overlapping_bodies().filter(func(b): return b is Enemy))
		for enemy in enemies:
			_remove_charmed_component_from_charmed_enemies(enemy as Enemy)
		_parent.speed /= _alluring_slow_amount
	queue_free()
