class_name Ada
extends BaseHero


onready var _frost_bolt_spawn: Spatial = $Mesh/FrostBoltSpawn


func _base_attack() -> void:
	_look_at_camera()
	yield(get_tree().create_timer(_tween.get_runtime()), "timeout")
	var frost_bold: KinematicBody = preload("res://characters/ada/frost_bolt.tscn").instance()
	frost_bold.global_transform = _frost_bolt_spawn.global_transform
	Gamemode.map.add_child(frost_bold)
