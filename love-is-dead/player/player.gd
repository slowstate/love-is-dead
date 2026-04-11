class_name Player
extends CharacterBody2D

const AUREAL = preload("uid://dwbtboe4r72fg")

# --- External Parameters -----------------------------------------------------
# --- Movement ---
@export var speed: float = 100.0
@export var acceleration: float = 1500.0
@export_range(0.0, 1.0, 0.1) var air_control: float = 0.4 # Multiplier for acceleration in the air
@export_range(0.0, 1.0, 0.1) var ground_friction: float = 0.8
@export_range(0.0, 1.0, 0.01) var air_friction: float = 0.05 # How much speed is lost in the air
@export var jump_velocity: float = -400.0
@export var extra_jumps: int = 0
# --- Combat ---
@export var primary_weapon: PrimaryWeapon.Type

var _jumps_remaining: int = 0
var _was_on_floor: bool = false
var _footsteps_timer: float = 0.0
# --- Combat ----
var _primary_weapon_cooldown_remaining: float = 0.0

@onready var player_audio: Node2D = $PlayerAudio


# --- Functions ---------------------------------------------------------------
func _init() -> void:
	GlobalInstances.player = self


func _physics_process(delta: float) -> void:
	_handle_primary_weapon(delta)
	_apply_gravity(delta)
	_handle_jump()
	_handle_horizontal_movement(delta)
	_detect_landing()
	_handle_footsteps(delta)
	move_and_slide()


# --- Movement ----------------------------------------------------------------
func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GlobalConstants.gravity * delta


func _handle_jump() -> void:
	if Input.is_action_just_pressed("player_jump"):
		if is_on_floor():
			_perform_jump()
		elif _jumps_remaining > 0:
			_perform_jump()
			_jumps_remaining -= 1
	else:
		if is_on_floor():
			_jumps_remaining = extra_jumps


func _perform_jump() -> void:
	velocity.y = jump_velocity
	player_audio.play_sfx("PlayerJump", 0.0, -20.0, -15.0, 0.9, 1.1)


func _detect_landing() -> void:
	var is_on_floor_now = is_on_floor()
	if not _was_on_floor and is_on_floor_now:
		player_audio.play_sfx("PlayerLand", 0.0, -15.0, -10.0, 0.9, 1.1)
	_was_on_floor = is_on_floor_now


func _handle_horizontal_movement(delta: float) -> void:
	var input_dir := Input.get_axis("player_move_left", "player_move_right")

	# Calculate Acceleration
	var current_accel = acceleration
	if not is_on_floor():
		current_accel *= air_control # Reduce the friction when in the air

	velocity.x += input_dir * current_accel * delta # Apply velocity

	# Apply Friction/Damping
	if input_dir == 0:
		if is_on_floor():
			velocity.x = lerp(velocity.x, 0.0, ground_friction)
		else:
			velocity.x = lerp(velocity.x, 0.0, air_friction)
	else:
		if abs(velocity.x) > speed:
			if is_on_floor():
				velocity.x = lerp(velocity.x, input_dir * speed, 0.1)
			else:
				velocity.x = lerp(velocity.x, input_dir * speed, air_friction)


func _handle_footsteps(delta: float) -> void:
	if is_on_floor() and velocity.x != 0.0:
		var _current_speed = abs(velocity.x)

		var _speed_ratio = clamp(_current_speed / (speed * 5), 0.0, 1.0)
		var _footsteps_interval = lerp(0.6, 0.2, _speed_ratio)
		_footsteps_timer -= delta

		if _footsteps_timer <= 0.0 and _current_speed > 20.0:
			player_audio.play_sfx("PlayerStep", 0.0, -10.0, -5.0, 0.9, 1.1)
			_footsteps_timer = _footsteps_interval


# --- Combat ------------------------------------------------------------------
func _handle_primary_weapon(delta: float) -> void:
	if _primary_weapon_cooldown_remaining > 0.0:
		_primary_weapon_cooldown_remaining -= min(delta, _primary_weapon_cooldown_remaining)
		return

	if Input.is_action_pressed("player_primary_weapon_fire"):
		var new_primary_weapon: PrimaryWeapon
		if primary_weapon == PrimaryWeapon.Type.Aureal:
			new_primary_weapon = AUREAL.instantiate() as Aureal

		if new_primary_weapon == null:
			return
		new_primary_weapon.global_position = global_position

		_primary_weapon_cooldown_remaining = new_primary_weapon.cooldown
		var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
		new_primary_weapon.try_fire(direction)
		get_tree().current_scene.add_child(new_primary_weapon)
		player_audio.play_sfx("PlayerShootArrow", 0.0, -15.0, -10.0, 0.9, 1.1)
