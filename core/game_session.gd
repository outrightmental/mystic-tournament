extends Node


signal started
signal about_to_start

var teams: Array
var map: Node = preload("res://maps/workshop_plane.tscn").instance()


puppetsync func start_game() -> void:
	emit_signal("about_to_start")
	var hero_scene: PackedScene = load("res://characters/ada/ada.tscn")
	for team in teams:
		for network_id in team:
			if network_id == 0:
				continue
			var player: Ada = hero_scene.instance()
			player.set_name("Player" + str(network_id))
			# warning-ignore:return_value_discarded
			player.connect("died", self, "_on_player_died")
			map.add_child(player)

			var controller := PlayerController.new()
			controller.set_network_master(network_id)
			controller.character = player
			add_child(controller)
	emit_signal("started")


func respawn_time(level: int) -> int:
	return level # TODO: Use formula


func _on_player_died(who: BaseHero, _by: BaseHero) -> void:
	who.visible = false
	yield(get_tree().create_timer(respawn_time(who.get_level())), "timeout")
	who.respawn(Vector3(0, 5, 0))
	who.visible = true
