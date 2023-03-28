extends Node3D

enum State {
	IDLE,
	ATTACK,
}

var current_state: State = State.IDLE

var rotation_target: Vector3 = Vector3(0, 0, 0)
var rotation_speed: float = 2.0

var attack_time: float = 0.0
var attack_speed: float = 0.4

@onready var bullet_spawn_1: Node3D = $BulletSpawn1
@onready var bullet_spawn_2: Node3D = $BulletSpawn2

@export var bullet_scene: PackedScene

var current_spawn: Node3D = bullet_spawn_1


func _ready() -> void:
	rotation_target = rotation


func _process(delta: float) -> void:
	match current_state:
		State.IDLE:
			pass
		State.ATTACK:
			update_attack(delta)
	update_rotation(delta)


func set_idle_state() -> void:
	current_state = State.IDLE


func set_attack_state() -> void:
	current_state = State.ATTACK


func set_rotation_target(target: Vector3) -> void:
	rotation_target = target


func update_rotation(delta: float) -> void:
	var step = clamp(rotation_speed * delta, 0, 1)
	var pitch = lerp(rotation.x, rotation_target.x, step)
	var yaw = lerp(rotation.y, rotation_target.y, step)
	var roll = lerp(rotation.z, rotation_target.z, step)
	rotation = Vector3(pitch, yaw, roll)


func update_attack(delta: float) -> void:
	if attack_time > attack_speed:
		current_spawn = bullet_spawn_1 if current_spawn == bullet_spawn_2 else bullet_spawn_2
		attack_time = 0.0

		var bullet = bullet_scene.instantiate()
		var root = get_tree().get_root()
		root.add_child(bullet)
		bullet.global_position = current_spawn.global_position
		bullet.rotation = Vector3(rotation.x, rotation.y + get_parent().rotation.y, rotation.z)
		bullet.set_travel_state()

	attack_time += delta
