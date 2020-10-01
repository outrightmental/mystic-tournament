extends Node


onready var _main_menu: MainMenu = $UI/MainMenu


func _ready() -> void:
	# warning-ignore:return_value_discarded
	Gamemode.connect("game_started", self, "_start_game", [], CONNECT_DEFERRED)


func _start_game() -> void:
	_main_menu.free()
	add_child(Gamemode.map)
