extends KinematicBody


const SPEED: int = 20


func _physics_process(delta: float) -> void:
	var collision: KinematicCollision = move_and_collide(-global_transform.basis.z.normalized() * delta * SPEED)
	if not collision:
		return
	
	if collision.collider.has_method("change_health"):
		collision.collider.change_health(-10)
	queue_free()
