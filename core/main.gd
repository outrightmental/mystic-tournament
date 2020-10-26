extends Node


onready var _main_menu: MainMenu = $UI/MainMenu


func _ready() -> void:
	# warning-ignore:return_value_discarded
	Gamemode.connect("game_started", self, "_start_game", [], CONNECT_DEFERRED)


func _start_game() -> void:
	_main_menu.free()
	add_child(Gamemode.map)

	var hero_scene: PackedScene = load("res://characters/base_hero/base_hero.tscn")
	for team in Gamemode.teams:
		for network_id in team:
			if network_id == 0:
				continue
			var player: BaseHero = hero_scene.instance()
			player.set_network_master(network_id)
			player.set_name("Player" + str(network_id))
			Gamemode.map.add_child(player)
