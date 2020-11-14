class_name BaseController
extends Node


# warning-ignore:unused_signal
signal base_attack_activated

var input_enabled: bool = true


func input_direction(_basis: Basis) -> Vector3:
	return Vector3.ZERO


func is_jumping() -> bool:
	return false
