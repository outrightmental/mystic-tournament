class_name PlayerController
extends BaseController


func _ready() -> void:
	set_physics_process(is_network_master())
	set_process_input(is_network_master())


func _input(event: InputEvent) -> void:
	if event.is_action_released("base_attack"):
		character.rotate_smoothly_to(_camera.rotation.y)
		yield(get_tree().create_timer(character.get_rotation_time()), "timeout")
		character.rpc("use_skill", BaseHero.BASE_ATTACK)


func _physics_process(delta: float) -> void:
	if not input_enabled:
		return

	var x_strength = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var z_strength = Input.get_action_strength("move_back") - Input.get_action_strength("move_front")

	var direction := Vector3()
	direction += _camera.global_transform.basis.x * x_strength
	direction += _camera.global_transform.basis.z * z_strength
	direction.y = 0

	if direction != Vector3.ZERO:
		character.rotate_smoothly_to(_camera.rotation.y)
	character.move(delta, direction.normalized(), Input.is_action_just_pressed("jump"))
