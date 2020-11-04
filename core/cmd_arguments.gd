extends Node


var server: bool


func _init() -> void:
	if not OS.has_feature("Server") and not "--no-window" in OS.get_cmdline_args():
		return

	if "--server" in OS.get_cmdline_args():
		server = true
