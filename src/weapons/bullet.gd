extends StaticBody3D

@onready var mesh: MeshInstance3D = $Mesh
@onready var trail: CPUParticles3D = $Trail
@onready var explosion: CPUParticles3D = $Explosion

var acceleration_speed: float = 5
var acceleration: float = 0
var attack_damage: float = 10
var speed: float = 40

var time: float = 0.0
var lifetime: float = 5.0

var grow_speed: float = 5
var shrink_speed: float = 10

enum State { IDLE, TRAVEL, DIE }

var current_state = State.IDLE


func _ready() -> void:
	var capsule = CapsuleMesh.new()
	capsule.radius = 0.05
	capsule.height = 0.1
	capsule.radial_segments = 8
	capsule.rings = 2
	mesh.mesh = capsule
	trail.visible = false
	trail.emitting = false
	explosion.visible = false
	explosion.emitting = false


func _process(delta) -> void:
	match current_state:
		State.IDLE:
			pass
		State.TRAVEL:
			travel(delta)
		State.DIE:
			dying(delta)


func set_travel_state() -> void:
	trail.visible = true
	trail.emitting = true
	current_state = State.TRAVEL


func set_die_state() -> void:
	die()
	current_state = State.DIE


func travel(delta) -> void:
	# Move forward with speed
	acceleration = clamp(acceleration + acceleration_speed * delta, 0, 1)
	var forward = global_transform.basis.x * speed * acceleration * -1
	if mesh.mesh.height < 3:
		mesh.mesh.height += delta * grow_speed
		mesh.position.x += delta * grow_speed * 0.5
	var collision = move_and_collide(forward * delta)

	time += delta
	if collision or time > lifetime:
		set_die_state()


func dying(delta) -> void:
	if mesh.mesh.height > 0.05:
		mesh.mesh.height -= delta * shrink_speed
		mesh.position.x -= delta * shrink_speed * 0.5
	else:
		mesh.visible = false
		current_state = State.IDLE


func die() -> void:
	trail.emitting = false
	explosion.visible = true
	explosion.emitting = true
	await get_tree().create_timer(1.0).timeout
	queue_free()
