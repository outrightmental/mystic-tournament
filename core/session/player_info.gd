class_name PlayerInfo
extends Node


var heroes: Array
var id: int


func _init(player_id: int) -> void:
	id = player_id


func get_damage_done() -> int:
	return Utils.accumulate_property(heroes, "damage_done")


func get_healing_done() -> int:
	return Utils.accumulate_property(heroes, "healing_done")


func get_deaths() -> int:
	return Utils.accumulate_property(heroes, "deaths")


func get_kills() -> int:
	return Utils.accumulate_property(heroes, "kills")
