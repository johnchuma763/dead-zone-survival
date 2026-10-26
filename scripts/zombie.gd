extends CharacterBody3D

var target: Node3D
var speed := 1.5

func _physics_process(delta):
    if not is_instance_valid(target):
        return

    var difference = target.global_position - global_position
    difference.y = 0

    if difference.length() > 1.5:
        var direction = difference.normalized()
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
        look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z))
    else:
        velocity.x = 0
        velocity.z = 0

    if not is_on_floor():
        velocity.y -= 20.0 * delta
    else:
        velocity.y = 0

    move_and_slide()
