class_name Charmed
extends Node

static var string_name = &"Charmed"

var _parent: Enemy


func _enter_tree() -> void:
	_parent = get_parent()
	if !_parent:
		queue_free()
	_parent.set_meta(string_name, self)


func _exit_tree() -> void:
	if _parent:
		_parent.remove_meta(string_name)

	if GlobalInstances.player:
		update_target(GlobalInstances.player)
	else:
		update_target(null)


func get_target() -> Node2D:
	return _parent.target


func update_target(new_target: Node2D) -> void:
	if _parent and _parent is Enemy:
		_parent.target = new_target
