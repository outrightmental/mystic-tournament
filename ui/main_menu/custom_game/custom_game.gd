extends HBoxContainer


onready var _servers: PanelContainer = $Servers
onready var _lobby: Lobby = $Lobby
onready var _server_settings: ServerSettings = $ServerSettings


func back() -> void:
	if _lobby.visible:
		_lobby.leave()
	else:
		hide()


func _switch_panels() -> void:
	_servers.visible = !_servers.visible
	_lobby.visible = !_lobby.visible


func _set_teams_editable(editable: bool) -> void:
	_server_settings.set_editable(editable)
	if editable:
		# warning-ignore:return_value_discarded
		_server_settings.enable_teams.connect("toggled", _lobby.teams_tree, "set_enable_teams")
		# warning-ignore:return_value_discarded
		_server_settings.teams_count.connect("value_changed", _lobby.teams_tree, "set_teams_count")
		# warning-ignore:return_value_discarded
		_server_settings.players_count.connect("value_changed", _lobby.teams_tree, "set_players_in_team")
	else:
		_server_settings.enable_teams.disconnect("toggled", _lobby.teams_tree, "set_enable_teams")
		_server_settings.teams_count.disconnect("value_changed", _lobby.teams_tree, "set_teams_count")
		_server_settings.players_count.disconnect("value_changed", _lobby.teams_tree, "set_players_in_team")
