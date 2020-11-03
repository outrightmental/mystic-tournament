extends Node


onready var _ui: UI = $UI


func _ready() -> void:
	# warning-ignore:return_value_discarded
	Gamemode.connect("game_started", self, "add_child", [Gamemode.map])
	# warning-ignore:return_value_discarded
	Gamemode.connect("game_started", _ui, "show_session_ui")
