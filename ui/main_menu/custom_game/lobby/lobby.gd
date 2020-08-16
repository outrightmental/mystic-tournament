extends PanelContainer


signal entered_lobby

onready var _error_dialog: ErrorDialog = $ErrorDialog
onready var _connection_dialog: ConnectionDialog = $ConnectionDialog


func join(address: String, port: int):
	var peer: = NetworkedMultiplayerENet.new()
	var error: int = peer.create_client(address, port)
	if error != OK:
		_error_dialog.show_error("Unable to create connection")
		return

	_connection_dialog.show_connecting(address)
	get_tree().set_network_peer(peer)

	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_process_join", [], CONNECT_ONESHOT)
	# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_process_failed_join", [], CONNECT_ONESHOT)


func _process_join() -> void:
	# Stop listening for failed connection
	get_tree().disconnect("connection_failed", self, "_process_failed_join")

	_connection_dialog.hide()


func _process_failed_join() -> void:
	# Stop listening for success connection
	get_tree().disconnect("connected_to_server", self, "_process_join")

	_connection_dialog.hide()
	_error_dialog.show_error("Unable to join lobby")
