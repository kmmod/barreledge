extends StaticBody3D

var attack_damage = 10
var speed = 50 


func _process(delta) -> void:
  travel(delta)


func travel(delta) -> void:
  # Move forward with speed
  # Forward vector by rotation
  var forward = global_transform.basis.x * speed * -1
  if (scale.x < 3):
    scale.x += delta * 10
  move_and_collide(forward * delta)
  
