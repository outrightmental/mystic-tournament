extends Node


func _ready() -> void:
	# warning-ignore:return_value_discarded
	GameSession.connect("started", self, "add_child", [GameSession.map])
