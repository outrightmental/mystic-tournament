class_name UI
extends Control
# Contains all game UI except player's HUD.


onready var _main_menu: MainMenu = $MainMenu
onready var _chat: Chat = $Chat


func show_session_ui():
	_main_menu.queue_free()
	_chat.move_upper()
