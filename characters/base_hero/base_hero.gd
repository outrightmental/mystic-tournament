class_name BaseHero
extends KinematicBody


signal died

enum {
	BASE_ATTACK
}

const MOVE_SPEED = 10
const JUMP_IMPULSE = 4
const MAX_HEALTH = 20

sync var health := MAX_HEALTH

var _controller: BaseController
var _motion: Vector3
var _velocity: Vector3
var _skils: Array

onready var _spring_arm: SpringArm = $SpringArm
onready var _floating_text: FloatingText = $FloatingText
onready var _tween: Tween = $Tween
onready var _mesh: MeshInstance = $Mesh
onready var _collision: CollisionShape = $Collision


func _init() -> void:
	rpc_config("set_global_transform", MultiplayerAPI.RPC_MODE_REMOTE)
	rpc_config("set_translation", MultiplayerAPI.RPC_MODE_SYNC)


func _ready() -> void:
	set_physics_process(_controller != null)


func _physics_process(delta: float) -> void:
	var direction: Vector3 = _controller.input_direction(_spring_arm.global_transform.basis)
	if direction != Vector3.ZERO:
		_look_at_camera()

	_motion = _motion.linear_interpolate(direction * MOVE_SPEED, Game.get_motion_interpolate_speed() * delta)

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

	_velocity = move_and_slide(new_velocity, Vector3.UP, true)
	# TODO: Replace with https://github.com/godotengine/godot/pull/37200
	rpc_unreliable("set_global_transform", get_global_transform())


func set_controller(controller: BaseController) -> void:
	if _controller:
		_controller.free()
	_controller = controller
	add_child(_controller)
	set_physics_process(_controller != null)

	# warning-ignore:return_value_discarded
	_controller.connect("skill_activated", self, "_use_skill")


func change_health(value: int) -> void:
	if health <= 0:
		return
	_floating_text.show_text(value)
	health = health + value
	if health <= 0:
		emit_signal("died")


func release_spirit() -> void:
	rpc("set_translation", Vector3(0, 30, 0))
	rset("health", MAX_HEALTH)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _use_skill(skill_type: int) -> void:
	_look_at_camera()
	yield(get_tree().create_timer(_tween.get_runtime()), "timeout")
	_skils[skill_type].use()


func _look_at_camera() -> void:
	# warning-ignore:return_value_discarded
	_tween.follow_property(_mesh, "rotation:y", _mesh.rotation.y,
			_spring_arm, "rotation:y", 0.1, Tween.TRANS_SINE, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	_tween.follow_property(_collision, "rotation:y", _collision.rotation.y,
			_spring_arm, "rotation:y", 0.1, Tween.TRANS_SINE, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	_tween.start()
