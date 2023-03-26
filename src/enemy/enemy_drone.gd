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


func _ready():
	# TODO: Player node should be defined as global variable
	# instead of relying on absolute path
	player = get_node("/root/main/Player")
	eye.rotation_change.connect(on_eye_rotation_change)


func _process(delta) -> void:
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


func on_eye_rotation_change(eye_rotation: Vector3) -> void:
	print("Changed", eye_rotation)
	turret.set_rotation_target(eye_rotation)
