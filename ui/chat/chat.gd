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
	# warning-ignore:return_value_discarded
	$InputField.connect("focus_exited", $AnimationPlayer, "play", ["hide_background"])


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if $InputField.has_focus():
			$InputField.accept_event()
			$InputField.release_focus()


master func _send_message(message: String) -> void:
	if message.empty():
		return
	rpc("_display_message", "white", "[[color=green]%d[/color]]: %s" % [get_tree().get_rpc_sender_id(), message])


puppetsync func _display_message(bbColor : String, message: String):
	$Panel/ChatWindow.bbcode_text += "\n%s [color=%s]%s[/color]" % [_time(), bbColor, message]


func _write_message(message: String) -> void:
	if message.empty():
		return
	$InputField.clear()
	rpc("_send_message", message)


func _announce_connected(id: int) -> void:
	_display_message("yellow", "%d has joined the game." % id)


func _announce_disconnected(id: int) -> void:
	_display_message("yellow", "%d has left the game." % id)


func _time() -> String:
	var time: Dictionary = OS.get_time()
	return "[color=gray][%02d:%02d:%02d][/color]" % [time.hour, time.minute, time.second]
