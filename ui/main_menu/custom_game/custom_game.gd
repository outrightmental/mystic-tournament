extends HBoxContainer


onready var _servers: PanelContainer = $Servers
onready var _lobby: Lobby = $Lobby
onready var _server_settings: ServerSettings = $ServerSettings
onready var _error_dialog: ErrorDialog = $ErrorDialog
onready var _connection_dialog: ConnectionDialog = $ConnectionDialog


func back() -> void:
	if _lobby.visible:
		_lobby.leave()
	else:
		hide()


func _create_lobby() -> void:
	_lobby.create()
	_server_settings.set_editable(true)
	_switch_to_lobby()


func _join_lobby(address: String, port: int) -> void:
	if _lobby.join(address, port) != OK:
		_error_dialog.show_error("Unable to create connection")
		return

	_connection_dialog.show_connecting(address, port)


func _on_joined() -> void:
	_connection_dialog.hide()
	_switch_to_lobby()


func _on_join_failed() -> void:
	_connection_dialog.hide()
	_error_dialog.show_error("Unable to join lobby")


func _on_created():
	_lobby.teams_tree.create(_server_settings.get_teams_count(), _server_settings.get_slots_count())
	# warning-ignore:return_value_discarded
	_server_settings.connect("teams_count_changed", _lobby.teams_tree, "set_teams_count")
	# warning-ignore:return_value_discarded
	_server_settings.connect("slots_count_changed", _lobby.teams_tree, "set_slots_count")


func _on_create_failed() -> void:
	_error_dialog.show_error("Unable to create server")


func _on_server_disconnected() -> void:
	_switch_to_servers()
	_error_dialog.show_error("Server was disconnected")


func _switch_to_servers() -> void:
	_servers.visible = true
	_lobby.visible = false
	_lobby.teams_tree.clear()
	_server_settings.set_editable(false)
	if _server_settings.is_connected("teams_count_changed", _lobby.teams_tree, "set_teams_count"):
		_server_settings.disconnect("teams_count_changed", _lobby.teams_tree, "set_teams_count")
	if _server_settings.is_connected("slots_count_changed", _lobby.teams_tree, "set_slots_count"):
		_server_settings.disconnect("slots_count_changed", _lobby.teams_tree, "set_slots_count")


func _switch_to_lobby() -> void:
	_servers.visible = false
	_lobby.visible = true
