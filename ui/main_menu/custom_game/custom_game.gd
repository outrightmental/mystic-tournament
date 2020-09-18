extends HBoxContainer


onready var _servers: PanelContainer = $Servers
onready var _lobby: Lobby = $Lobby
onready var _server_settings: ServerSettings = $ServerSettings
onready var _direct_connect_dialog: DirectConnectDialog = $DirectConnectDialog
onready var _error_dialog: ErrorDialog = $ErrorDialog
onready var _connection_dialog: ConnectionDialog = $ConnectionDialog


func back() -> void:
	if _lobby.visible:
		_lobby.leave()
	else:
		hide()


func _switch_to_servers() -> void:
	_servers.visible = true
	_lobby.visible = false


func _switch_to_lobby() -> void:
	_servers.visible = false
	_lobby.visible = true


func _create_lobby() -> void:
	_lobby.create(_server_settings.get_teams_count(), _server_settings.get_slots_count())

	_switch_to_lobby()


func _direct_join_lobby() -> void:
	if _lobby.join(_direct_connect_dialog.address, _direct_connect_dialog.port) != OK:
		_error_dialog.show_error("Unable to create connection")
		return

	_connection_dialog.show_connecting(_direct_connect_dialog.address, _direct_connect_dialog.port)


func _on_successful_join() -> void:
	_connection_dialog.hide()
	_switch_to_lobby()


func _on_failed_join() -> void:
	_connection_dialog.hide()
	_error_dialog.show_error("Unable to join lobby")


func _on_creation_error() -> void:
	_error_dialog.show_error("Unable to create server")


func _set_teams_editable(editable: bool) -> void:
	_server_settings.set_editable(editable)
	if editable:
		# warning-ignore:return_value_discarded
		_server_settings.connect("teams_count_changed", _lobby.teams_tree, "set_teams_count")
		# warning-ignore:return_value_discarded
		_server_settings.connect("slots_count_changed", _lobby.teams_tree, "set_slots_count")
	else:
		_server_settings.disconnect("teams_count_changed", _lobby.teams_tree, "set_teams_count")
		_server_settings.disconnect("slots_count_changed", _lobby.teams_tree, "set_slots_count")
