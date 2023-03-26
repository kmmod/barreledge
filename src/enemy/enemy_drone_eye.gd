extends Node3D

@export var angle_limit: float = 10

signal rotation_change

enum State { IDLE, FOLLOW }

var follow_target: Vector3 = Vector3(0, 0, 0)

var current_state = State.IDLE

var next_idle_time = 0
var current_time = 0
var rotation_target = Vector2(0, 0)
var rotation_speed = 10.0


func _ready() -> void:
	rotation_target = Vector3(0, rotation.y, rotation.z)


func _process(delta: float) -> void:
	# State switch is controlled by parent node
	match current_state:
		State.IDLE:
			update_idle_state(delta)
		State.FOLLOW:
			update_follow_state()
	update_eye_rotation(delta)


func set_follow_state(target: Vector3) -> void:
	follow_target = target
	transition_to_state(State.FOLLOW)


func set_idle_state() -> void:
	transition_to_state(State.IDLE)


func transition_to_state(new_state) -> void:
	current_state = new_state


func update_idle_state(delta: float) -> void:
	if current_time > next_idle_time:
		var yaw_target = deg_to_rad(randf() * angle_limit - angle_limit / 2)
		var pitch_target = deg_to_rad(randf() * angle_limit - angle_limit / 2)
		rotation_target = Vector3(0, yaw_target, pitch_target)
		next_idle_time = randf() * 2
		rotation_change.emit(rotation_target)
		current_time = 0
	else:
		current_time += delta

	var step = clamp(rotation_speed * delta, 0, 1)
	var yaw = lerp(rotation.y, rotation_target.y, step)
	var pitch = lerp(rotation.z, rotation_target.z, step)

	rotation = Vector3(0, yaw, pitch)


func update_follow_state() -> void:
	rotation_target = Vector3(0, 0, 0)


func update_eye_rotation(delta: float) -> void:
	var step = clamp(rotation_speed * delta, 0, 1)
	var yaw = lerp(rotation.y, rotation_target.y, step)
	var pitch = lerp(rotation.z, rotation_target.z, step)

	rotation = Vector3(0, yaw, pitch)

