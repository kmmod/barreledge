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

# TODO: Whats ia a better way to handle dependencies?
# Maybe with export node path?
@onready var eye: MeshInstance3D = $Eye
@onready var turret: MeshInstance3D = $Turret
@onready var helper: Node3D = $Helper


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
			update_attack_state()
			pass
		State.DEAD:
			pass
		State.CHASE:
			pass
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
			turret.set_idle_state()
		State.ATTACK:
			turret.set_attack_state()
		State.DEAD:
			pass
		State.CHASE:
			pass
		State.PATROL:
			pass
		State.RUN:
			pass

	# Set the current state to the new state
	current_state = new_state


func on_eye_rotation_change(eye_rotation: Vector3) -> void:
	print("Changed", eye_rotation)
	# turret.set_rotation_target(eye_rotation)


func update_attack_state() -> void:
	# direction from drone to player
	# var forward = global_transform.basis.z
	var forw = Vector3.FORWARD
	var dir = position.direction_to(player.position)
	var rot = Vector3(dir.x, dir.y, dir.z) 
	helper.rotation = rot
	# var rot = Vector3(0, dir.y, 0)
	# var rot = global_transform.looking_at(player.position, Vector3.UP).origin.normalized()
	print("Direction to player", rot)
	turret.set_rotation_target(rot)
