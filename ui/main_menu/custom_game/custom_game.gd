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


func _create_lobby() -> void:
	_lobby.create(_server_settings.get_teams_count(), _server_settings.get_slots_count())

	_servers.visible = false
	_lobby.visible = true


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
