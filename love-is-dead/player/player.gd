class_name Player
extends CharacterBody2D

# --- Movement paramters ------------------------------------------------------
@export var speed: float = 100.0
@export var acceleration: float = 1500.0
@export_range(0.0, 1.0, 0.1) var air_control: float = 0.4 # Multiplier for acceleration in the air
@export_range(0.0, 1.0, 0.1) var ground_friction: float = 0.8
@export_range(0.0, 1.0, 0.01) var air_friction: float = 0.05 # How much speed is lost in the air
@export var jump_velocity: float = -400.0
@export var extra_jumps: int = 0

var _jumps_remaining: int = 0


# --- Functions ---------------------------------------------------------------
func _init() -> void:
	GlobalInstances.player = self


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_jump()
	_handle_horizontal_movement(delta)
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
