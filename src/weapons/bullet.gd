extends StaticBody3D

var attack_damage = 10
var speed = 50


enum State {
	TRAVEL,
	DIE
}

var current_state = State.TRAVEL


func _process(delta) -> void:
	match current_state:
		State.TRAVEL:
			travel(delta)
		State.DIE:
			die(delta)


func travel(delta) -> void:
	# Move forward with speed
	# Forward vector by rotation
	var forward = global_transform.basis.x * speed * -1
	if scale.x < 3:
		scale.x += delta * 10
	var collision = move_and_collide(forward * delta)

	if collision:
		# If collided with something, destroy self
		queue_free()


func die() -> void:
	# TODO: Create explosion effect (particles)
	# Rmove MeshInstance
	# Wait 1 second
	# Queue free
	pass
