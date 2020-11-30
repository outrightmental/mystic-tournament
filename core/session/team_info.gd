class_name TeamInfo
extends Node


var players: Array


func _init(player_ids: Array) -> void:
	for id in player_ids:
		players.append(PlayerInfo.new(id))


func get_damage_done() -> int:
	return Utils.accumulate_function(players, "get_damage_done")


func get_healing_done() -> int:
	return Utils.accumulate_function(players, "get_healing_done")


func get_deaths() -> int:
	return Utils.accumulate_function(players, "get_deaths")


func get_kills() -> int:
	return Utils.accumulate_function(players, "get_kills")
