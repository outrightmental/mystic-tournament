class_name BaseHero
extends KinematicBody


signal died(sender, by)

enum {
	BASE_ATTACK
}

const MOVE_SPEED = 10
const JUMP_IMPULSE = 4
const MAX_HEALTH = 20

sync var health := MAX_HEALTH

var _motion: Vector3
var _velocity: Vector3
var _abilities: Dictionary
var _abilities_spawn_positions: Dictionary

onready var _floating_text: FloatingText = $FloatingText
onready var _rotation_tween: Tween = $RotationTween
onready var _mesh: MeshInstance = $Mesh
onready var _collision: CollisionShape = $Collision


func _init() -> void:
	rset_config("global_transform", MultiplayerAPI.RPC_MODE_REMOTE)


func move(delta: float, direction: Vector3, jumping: bool) -> void:
	_motion = _motion.linear_interpolate(direction * MOVE_SPEED, Game.get_motion_interpolate_speed() * delta)

	var new_velocity: Vector3
	if is_on_floor():
		new_velocity = _motion
		if jumping:
			new_velocity.y = JUMP_IMPULSE
		else:
			new_velocity.y = -Game.get_gravity()
	else:
		new_velocity = _velocity.linear_interpolate(_motion, Game.get_velocity_interpolate_speed() * delta)
		new_velocity.y = _velocity.y - Game.get_gravity() * delta

	_velocity = move_and_slide(new_velocity, Vector3.UP, true)
	# TODO: Replace with https://github.com/godotengine/godot/pull/37200
	rset_unreliable("global_transform", global_transform)


puppetsync func rotate_smoothly_to(y_radians: float) -> void:
	# warning-ignore:return_value_discarded
	_rotation_tween.interpolate_property(_mesh, "rotation:y", _mesh.rotation.y,
			y_radians, 0.1, Tween.TRANS_SINE, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	_rotation_tween.interpolate_property(_collision, "rotation:y", _collision.rotation.y,
			y_radians, 0.1, Tween.TRANS_SINE, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	_rotation_tween.start()


puppetsync func use_ability(ability_type: int) -> void:
	_abilities[ability_type].use(self, _abilities_spawn_positions.get(ability_type).global_transform)


func get_level() -> int:
	return 1 # TODO: Use internal variable


func get_rotation_time() -> float:
	return _rotation_tween.get_runtime()


func change_health(value: int, by: BaseHero = null) -> void:
	if health <= 0:
		return
	_floating_text.show_text(value)
	health = health + value
	if health <= 0:
		emit_signal("died", self, by)


func respawn(position: Vector3) -> void:
	translation = position
	health = MAX_HEALTH
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
