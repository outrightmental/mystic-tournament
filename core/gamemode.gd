extends Node
# Represents current game rules


signal game_started
signal game_about_to_start

var teams: Array
var map: Node = preload("res://maps/workshop_plane.tscn").instance()


puppetsync func start_game() -> void:
	emit_signal("game_about_to_start")
	emit_signal("game_started")
