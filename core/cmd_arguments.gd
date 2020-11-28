extends Node


var server: bool
var direct_connect: bool


func _init() -> void:
	if "--server" in OS.get_cmdline_args():
		server = true
	elif "--connect" in OS.get_cmdline_args():
		direct_connect = true
