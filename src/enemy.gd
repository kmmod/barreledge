extends CharacterBody3D

# The speed at which the enemy moves
@export var speed = 10

# The distance at which the enemy detects the player
@export var detection_range = 20

# The minimum distance at which the enemy will start attacking the player
@export var attack_range = 5

# The damage dealt by the enemy's attacks
@export var damage = 10

# The time between the enemy's attacks
@export var attack_delay = 1

# The player character
var player

# The time remaining until the enemy can attack again
var attack_timer = 0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

# The current state of the enemy
enum State {
	IDLE,
	PATROL,
	CHASE,
	ATTACK,
}

var current_state = State.IDLE


func _ready():
	# Get a reference to the player character
	player = get_node("/root/main/Player")

	# Initialize the state machine
	transition_to_state(State.IDLE)


func _process(delta):
	# Call the appropriate function for the current state
	match current_state:
		State.IDLE:
			update_idle_state()
		State.PATROL:
			update_patrol_state()
		State.CHASE:
			update_chase_state()
		State.ATTACK:
			update_attack_state(delta)


func transition_to_state(new_state):
	# Exit the current state
	match current_state:
		State.IDLE:
			pass
		State.PATROL:
			pass
		State.CHASE:
			pass
		State.ATTACK:
			pass

	# Enter the new state
	match new_state:
		State.IDLE:
			pass
		State.PATROL:
			pass
		State.CHASE:
			pass
		State.ATTACK:
			pass

	# Set the current state to the new state
	current_state = new_state


func _physics_process(delta) -> void:
	# Call the appropriate function for the current state
	if not is_on_floor():
		velocity.y -= gravity * delta


func update_idle_state() -> void:
	# Calculate the distance between the enemy and the player
	var distance_to_player = position.distance_to(player.position)

	# If the player is within the detection range, transition to the CHASE state
	if distance_to_player <= detection_range:
		transition_to_state(State.CHASE)


func update_patrol_state() -> void:
	print("Patrol state. Not implemented!")


func update_chase_state() -> void:
	# Calculate the distance between the enemy and the player
	var distance_to_player = position.distance_to(player.position)

	# If the player is within attack range, transition to the ATTACK state
	if distance_to_player <= attack_range:
		transition_to_state(State.ATTACK)
	# Move towards the player
	else:
		var direction = (player.position - position).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		move_and_slide()


func update_attack_state(delta: float) -> void:
	# Calculate the distance between the enemy and the player
	var distance_to_player = position.distance_to(player.position)

	# If the attack timer has expired, deal damage to the player
	if attack_timer <= 0:
		player.take_damage(damage)

		# Reset the attack timer
		attack_timer = attack_delay

	# If the player is outside of attack range, transition back to the CHASE state
	if distance_to_player > attack_range:
		transition_to_state(State.CHASE)

	# Decrement the attack timer
	attack_timer -= delta
