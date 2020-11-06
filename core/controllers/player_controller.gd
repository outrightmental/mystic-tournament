class_name PlayerController
extends BaseController


func input_direction(basis: Basis) -> Vector3:
	if not input_enabled:
		return Vector3.ZERO

	var x_strength = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var z_strength = Input.get_action_strength("move_back") - Input.get_action_strength("move_front")

	var direction := Vector3()
	direction += basis.x * x_strength
	direction += basis.z * z_strength
	direction.y = 0
	return direction.normalized()


func is_jumping() -> bool:
	return input_enabled and Input.is_action_just_pressed("jump")
