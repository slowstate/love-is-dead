class_name Needles
extends Node

const TRIGGER_PARTICLES = preload("uid://b6vcahoqgt2f6")

static var string_name = &"Needles"

var needle_amount: int = 0
var _needle_damage: int = 10
var _parent: Enemy
var _needle_sprites: Array[Sprite2D]


func _enter_tree() -> void:
	_parent = get_parent()
	if !_parent:
		queue_free()
	_parent.set_meta(string_name, self)


func _ready() -> void:
	_needle_sprites.assign(get_children().filter(func(node): return node is Sprite2D))
	for sprite in _needle_sprites:
		sprite.rotate(randf_range(-2 * PI / 8, 2 * PI / 8))


func _exit_tree() -> void:
	if _parent:
		_parent.remove_meta(string_name)


func add_needles(amount: int) -> void:
	needle_amount += amount
	for needle in min(needle_amount, get_children().size()):
		_needle_sprites[needle].visible = true


func trigger_needles() -> void:
	_parent.take_damage(needle_amount * _needle_damage)
	var trigger_particles: GPUParticles2D = TRIGGER_PARTICLES.instantiate()
	trigger_particles.global_position = _parent.global_position
	get_tree().current_scene.add_child(trigger_particles)
	trigger_particles.amount = needle_amount
	trigger_particles.emitting = true
	queue_free()
