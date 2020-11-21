class_name BaseController
extends Node
# TODO: Extend from https://github.com/godotengine/godot/pull/37200


var input_enabled: bool = true
var character: BaseHero setget set_character

var _camera: PlayerCamera = preload("res://core/controllers/player_camera.tscn").instance()


func set_character(new_character: BaseHero) -> void:
	if character:
		character.remove_child(_camera)
	character = new_character
	character.add_child(_camera)
	character.set_network_master(get_network_master(), true)

