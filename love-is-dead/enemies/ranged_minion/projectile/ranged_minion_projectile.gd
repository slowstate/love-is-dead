class_name RangedMinionProjectile
extends RigidBody2D

var lifetime: float = 1.0
var speed: float = 600.0
var damage: int = 10
var _lifetime_elapsed: float = 0.0
var _has_hit: bool = false

@onready var hitbox: Area2D = $Hitbox


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	hitbox.area_entered.connect(_on_player_entered)


func _physics_process(delta: float) -> void:
	_lifetime_elapsed += delta
	if _lifetime_elapsed >= lifetime:
		queue_free()
		return


func fire(direction: Vector2) -> void:
	apply_central_impulse(direction * speed * mass)


func _on_body_entered(_body: Node2D) -> void:
	queue_free()


func _on_player_entered(player_hurtbox: Area2D) -> void:
	var player = player_hurtbox.owner as Player
	if player != null and player is Player and !_has_hit:
		_has_hit = true
		player.take_damage(damage)
		queue_free()
