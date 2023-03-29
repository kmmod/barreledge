extends CharacterBody3D

@export var speed = 5.0
@export var detection_range = 20
@export var attack_range = 10

# Those should be controlled by turret component and by
# amunition type instead of hard coded
@export var attack_damage = 10
@export var attack_speed = 1.0

var player = null

var attack_timer = 0.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

enum State {
	IDLE,
	ATTACK,
	DEAD,
	CHASE,
	PATROL,
	RUN,
}

var current_state = State.IDLE

var rotation_target = Vector3(0, 0, 0)
var rotation_speed = 4

# TODO: Whats ia a better way to handle dependencies?
# Maybe with export node path?
@onready var eye: MeshInstance3D = $Eye
@onready var turret: MeshInstance3D = $Turret
@onready var raycast: RayCast3D = $RayCast3D


func _ready():
	# TODO: Player node should be defined as global variable
	# instead of relying on absolute path
	player = get_node("/root/main/Player")
	eye.rotation_change.connect(on_eye_rotation_change)
	transition_to_state(State.ATTACK)


func _process(delta) -> void:
	match current_state:
		State.IDLE:
			pass
		State.ATTACK:
			update_rotation(delta)
			update_attack_state()
		State.DEAD:
			pass
		State.CHASE:
			update_rotation(delta)
			update_chase_state(delta)
		State.PATROL:
			pass
		State.RUN:
			pass


func transition_to_state(new_state):
	# Exit the current state
	match current_state:
		State.IDLE:
			pass
		State.ATTACK:
			pass
		State.DEAD:
			pass
		State.CHASE:
			pass
		State.PATROL:
			pass
		State.RUN:
			pass

	# Enter the new state
	match new_state:
		State.IDLE:
			eye.set_idle_state()
			turret.set_idle_state()
		State.ATTACK:
			eye.set_follow_state()
			turret.set_attack_state()
		State.DEAD:
			pass
		State.CHASE:
			eye.set_idle_state()
			turret.set_idle_state()
		State.PATROL:
			pass
		State.RUN:
			pass

	# Set the current state to the new state
	current_state = new_state


func on_eye_rotation_change(eye_rotation: Vector3) -> void:
	turret.set_rotation_target(eye_rotation)


func update_rotation(delta: float) -> void:
	var step = clamp(rotation_speed * delta, 0, 1)
	rotation.y = lerp_angle(rotation.y, rotation_target.y, step)


func is_player_in_range(max_range: float) -> bool:
	var player_pos = player.position + Vector3(0, 1.5, 0)
	var distance = position.distance_to(player_pos)
	return distance < max_range


func update_idle_state() -> void:
	if is_player_in_range(detection_range):
		transition_to_state(State.CHASE)


func update_patrol_state() -> void:
	pass


func update_chase_state(delta: float) -> void:
	var target_pos = Vector3(player.position.x, position.y, player.position.z)
	raycast.target_position = target_pos
	if raycast.is_colliding():
		print("Player is not visible")

	velocity = (target_pos - position).normalized() * speed * delta
	move_and_slide()

	if is_player_in_range(attack_range):
		transition_to_state(State.ATTACK)



func update_run_state() -> void:
	pass


func update_dead_state() -> void:
	pass


func update_attack_state() -> void:
	var player_pos = player.position + Vector3(0, 1.5, 0)
	var drone_direction = position.direction_to(player_pos)
	var drone_yaw = atan2(drone_direction.x, drone_direction.z)
	rotation_target = Vector3(0, drone_yaw + PI / 2, 0)

	var turret_pos = position + turret.position

	var xz_distance = turret_pos.distance_to(Vector3(player_pos.x, turret_pos.y, player_pos.z))
	var y_distance = turret_pos.y - player_pos.y
	var pitch = atan2(y_distance, xz_distance)

	var turret_target = Vector3(0, 0, pitch)
	turret.set_rotation_target(turret_target)

	var eye_target = Vector3(0, 0, pitch)
	eye.set_rotation_target(eye_target)

	if not is_player_in_range(attack_range):
		transition_to_state(State.CHASE)
