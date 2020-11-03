class_name UI
extends Control


onready var _main_menu: MainMenu = $MainMenu


func show_session_ui():
	_main_menu.queue_free()
