extends VBoxContainer


func _ready() -> void:
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_announce_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_announce_disconnected")
	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_display_message", ["gray", "You joined the game."])
	# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_display_message", ["gray", "You left the game."])


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if $InputField.has_focus():
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$InputField.accept_event()
			$InputField.release_focus()
	elif event.is_action_pressed("ui_accept"):
		if not $InputField.has_focus():
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$InputField.accept_event()
			$InputField.grab_focus()


master func _send_message(message: String) -> void:
	rpc("_display_message", "white", "[[color=green]%d[/color]]: %s" % [get_tree().get_rpc_sender_id(), message])


puppetsync func _display_message(bbColor : String, message: String):
	$Panel/ChatWindow.bbcode_text += "\n%s [color=%s]%s[/color]" % [_time(), bbColor, message]


func _write_message(message: String) -> void:
	$InputField.clear()
	rpc("_send_message", message)


func _announce_connected(id: int) -> void:
	_display_message("yellow", "%d has joined the game." % id)


func _announce_disconnected(id: int) -> void:
	_display_message("yellow", "%d has left the game." % id)


func _time() -> String:
	var time: Dictionary = OS.get_time()
	return "[color=gray][%02d:%02d:%02d][/color]" % [time.hour, time.minute, time.second]
