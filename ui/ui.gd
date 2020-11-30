class_name UI
extends Control
# Contains all game UI except player's HUD.


onready var _main_menu: MainMenu = $MainMenu
onready var _chat: Chat = $Chat


func _ready() -> void:
	# warning-ignore:return_value_discarded
	GameSession.connect("started", self, "_on_session_started")


func _on_session_started():
	_main_menu.queue_free()
	_chat.move_upper()
