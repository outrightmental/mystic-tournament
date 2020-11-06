class_name BaseHero
extends KinematicBody


signal died

const MOVE_SPEED = 10
const JUMP_IMPULSE = 4
const MAX_HEALTH = 20

sync var health := MAX_HEALTH

var _controller: BaseController
var _motion: Vector3
var _velocity: Vector3

onready var _spring_arm: SpringArm = $SpringArm
onready var _floating_text: FloatingText = $FloatingText


func _init() -> void:
	set_physics_process(false)
	rpc_config("set_global_transform", MultiplayerAPI.RPC_MODE_REMOTE)
	rpc_config("set_translation", MultiplayerAPI.RPC_MODE_SYNC)


func _physics_process(delta: float) -> void:
	var direction: Vector3 = _controller.input_direction(_spring_arm.global_transform.basis)
	_motion = _motion.linear_interpolate(direction * MOVE_SPEED, Game.get_motion_interpolate_speed() * delta)
	_velocity = move_and_slide(calculate_velocity(delta), Vector3.UP, true)
	rpc_unreliable("set_global_transform", get_global_transform())


func set_controller(controller: BaseController) -> void:
	if _controller:
		_controller.free()
	_controller = controller
	add_child(_controller)
	set_physics_process(_controller != null)


func change_health(value: int) -> void:
	if health <= 0:
		return
	_floating_text.show_text(value)
	health = health + value
	if health <= 0:
		emit_signal("died")


func calculate_velocity(delta: float) -> Vector3:
	var new_velocity: Vector3
	if is_on_floor():
		new_velocity = _motion
		if _controller.is_jumping():
			new_velocity.y = JUMP_IMPULSE
		else:
			new_velocity.y = -Game.get_gravity()
	else:
		new_velocity = _velocity.linear_interpolate(_motion, Game.get_velocity_interpolate_speed() * delta)
		new_velocity.y = _velocity.y - Game.get_gravity() * delta
	return new_velocity


func release_spirit() -> void:
	rpc("set_translation", Vector3(0, 30, 0))
	rset("health", MAX_HEALTH)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
