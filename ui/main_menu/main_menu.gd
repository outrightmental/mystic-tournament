extends Control


var current_window: Node


func _open(window_name: String) -> void:
	current_window = get_node(window_name)
	current_window.show()


func _back() -> void:
	current_window.back()
