class_name Splitter
extends Weapon

const SPLITTER_ARROW = preload("uid://d3l6suglyrjry")


func _init() -> void:
	cooldown = 0.5


func fire(direction: Vector2) -> void:
	var arrow: SplitterArrow = SPLITTER_ARROW.instantiate()
	arrow.rotation = direction.angle()
	arrow.global_position = GlobalInstances.player.global_position
	Engine.get_main_loop().current_scene.add_child(arrow)
	arrow.fire(direction)
