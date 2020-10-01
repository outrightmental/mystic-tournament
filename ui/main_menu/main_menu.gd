class_name MainMenu
extends Control


onready var _exit_dialog: ExitDialog = $ExitDialog

var _current_window: Control


func _open(window_name: String) -> void:
	_current_window = get_node(window_name)
	_current_window.show()


func _back() -> void:
	if _current_window == null:
		_exit_dialog.popup_centered()
		return
		
	_current_window.back()
	if _current_window.visible == false:
		_current_window = null
