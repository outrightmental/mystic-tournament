extends Node


onready var _ui: UI = $UI


func _ready() -> void:
	# warning-ignore:return_value_discarded
	GameSession.connect("started", self, "add_child", [GameSession.map])
	# warning-ignore:return_value_discarded
	GameSession.connect("started", _ui, "show_session_ui")
