class_name Player
extends CharacterBody2D

# --- External Parameters -----------------------------------------------------
# --- Movement ---
@export var speed: float = 200.0
@export var acceleration: float = 1500.0
@export_range(0.0, 1.0, 0.1) var air_control: float = 0.4 # Multiplier for acceleration in the air
@export_range(0.0, 1.0, 0.1) var ground_friction: float = 0.8
@export_range(0.0, 1.0, 0.01) var air_friction: float = 0.7 # How much speed is lost in the air
@export var jump_velocity: float = -320.0
@export var extra_jumps: int = 0
@export var ladder_climb_speed: float = 8000.0
# --- Combat ---
@export var primary_weapon_scene: PackedScene
@export var secondary_weapon_scene: PackedScene
@export var ladder_tile_map_layer: TileMapLayer

# --- Internal Parameters -----------------------------------------------------
# --- Movement ---
var _jumps_remaining: int = 0
var _on_ladder: bool = false
# --- Combat ----
var _primary_weapon_cooldown_remaining: float = 0.0
var _secondary_weapon_cooldown_remaining: float = 0.0

@onready var ladder_detector_down: RayCast2D = $LadderDetectorDown
@onready var ladder_detector_up: RayCast2D = $LadderDetectorUp
@onready var ladder_collision_detector: RayCast2D = $LadderCollisionDetector
@onready var collision_box: CollisionShape2D = $CollisionBox


# --- Functions ---------------------------------------------------------------
func _init() -> void:
	GlobalInstances.player = self


func _ready() -> void:
	if GlobalInstances.player_weapon_loadout:
		primary_weapon_scene = GlobalInstances.player_weapon_loadout.primary_weapon
		secondary_weapon_scene = GlobalInstances.player_weapon_loadout.secondary_weapon


func _physics_process(delta: float) -> void:
	_handle_primary_weapon(delta)
	_handle_secondary_weapon(delta)
	_apply_gravity(delta)
	_handle_jump()
	_handle_horizontal_movement(delta)
	_handle_ladder_movement(delta)
	move_and_slide()


# --- Movement ----------------------------------------------------------------
func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GlobalConstants.gravity * delta


func _handle_jump() -> void:
	if Input.is_action_just_pressed("player_jump"):
		if _on_ladder and !ladder_collision_detector.is_colliding():
			var ladder_jump_velocity: float = jump_velocity
			if ladder_detector_up.is_colliding():
				ladder_jump_velocity = jump_velocity * 1.2
			_on_ladder = false
			collision_box.disabled = false
			ladder_detector_up.enabled = false
			ladder_detector_down.enabled = false

			_perform_jump(ladder_jump_velocity)
			await get_tree().create_timer(0.5).timeout
			ladder_detector_up.enabled = true
			ladder_detector_down.enabled = true
		elif is_on_floor():
			_perform_jump()
		elif _jumps_remaining > 0:
			_perform_jump()
			_jumps_remaining -= 1
	else:
		if is_on_floor():
			_jumps_remaining = extra_jumps


func _perform_jump(custom_jump_velocity: float = jump_velocity) -> void:
	velocity.y = custom_jump_velocity


func _handle_horizontal_movement(delta: float) -> void:
	if _on_ladder:
		return
	var input_dir: float = Input.get_axis("player_move_left", "player_move_right")

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
				velocity.x = lerp(velocity.x, input_dir * speed, ground_friction)
			else:
				velocity.x = lerp(velocity.x, input_dir * speed, air_friction)


func _handle_ladder_movement(delta: float) -> void:
	if ladder_tile_map_layer == null:
		return
	if Input.is_action_pressed("player_climb_up"):
		if ladder_detector_up.is_colliding():
			_on_ladder = true
			collision_box.disabled = true
		else:
			_on_ladder = false
			collision_box.disabled = false
			return
	if Input.is_action_pressed("player_climb_down"):
		if ladder_detector_down.is_colliding():
			_on_ladder = true
			collision_box.disabled = true
		else:
			_on_ladder = false
			collision_box.disabled = false
			return

	if !_on_ladder:
		return

	var local_collision_point: Vector2
	if ladder_detector_up.is_colliding():
		local_collision_point = ladder_tile_map_layer.to_local(ladder_detector_up.get_collision_point())
	else:
		local_collision_point = ladder_tile_map_layer.to_local(ladder_detector_down.get_collision_point())

	# Clip player to centre of ladder
	var coords = ladder_tile_map_layer.local_to_map(local_collision_point)
	var coords_pos = ladder_tile_map_layer.map_to_local(coords)
	var desired_x_pos = ladder_tile_map_layer.to_global(coords_pos).x
	if global_position.x != desired_x_pos:
		var x_pos_tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
		x_pos_tween.tween_property(self, "global_position:x", desired_x_pos, 0.05)

	# Ladder Movement
	var input_dir_y: float = Input.get_action_strength("player_climb_down") - Input.get_action_strength("player_climb_up")
	velocity.y = input_dir_y * ladder_climb_speed * delta
	velocity.x = 0.0


# --- Combat ------------------------------------------------------------------
func _handle_primary_weapon(delta: float) -> void:
	if _primary_weapon_cooldown_remaining > 0.0:
		_primary_weapon_cooldown_remaining -= min(delta, _primary_weapon_cooldown_remaining)
		return

	if Input.is_action_pressed("player_primary_weapon_fire"):
		if Input.is_action_pressed("player_primary_weapon_fire") and primary_weapon_scene:
			var weapon := primary_weapon_scene.instantiate() as Weapon
			weapon.global_position = global_position
			get_tree().current_scene.add_child(weapon)
			_primary_weapon_cooldown_remaining = weapon.cooldown
			weapon.fire()


func _handle_secondary_weapon(delta: float) -> void:
	if _secondary_weapon_cooldown_remaining > 0.0:
		_secondary_weapon_cooldown_remaining -= min(delta, _secondary_weapon_cooldown_remaining)
		return
	if Input.is_action_pressed("player_secondary_weapon_fire") and secondary_weapon_scene:
		var weapon := secondary_weapon_scene.instantiate() as Weapon
		weapon.global_position = get_global_mouse_position()
		get_tree().current_scene.add_child(weapon)
		_secondary_weapon_cooldown_remaining = weapon.cooldown
		weapon.fire()
