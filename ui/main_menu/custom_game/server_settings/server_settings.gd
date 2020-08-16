extends PanelContainer


onready var _enable_teams: CheckBox = $VBox/EnableTeams
onready var _teams_count: SpinBox = $VBox/TeamsCount/SpinBox
onready var _players_count: SpinBox = $VBox/PlayersCount/SpinBox


func _ready():
	set_editable(false)

	# Allow to sync server configuration over network
	_enable_teams.rset_config("pressed", MultiplayerAPI.RPC_MODE_PUPPET)
	_teams_count.rset_config("value", MultiplayerAPI.RPC_MODE_PUPPET)
	_players_count.rset_config("value", MultiplayerAPI.RPC_MODE_PUPPET)


func set_editable(editable: bool):
	if editable:
		_enable_teams.disabled = false
		_teams_count.editable = true
		_players_count.editable = true
		# warning-ignore:return_value_discarded
		_teams_count.connect("value_changed", self, "_set_teams_count")
		# warning-ignore:return_value_discarded
		_players_count.connect("value_changed", self, "_set_players_count")
		# warning-ignore:return_value_discarded
		_enable_teams.connect("toggled", self, "_set_teams_enabled")
	else:
		_enable_teams.disabled = true
		_teams_count.editable = false
		_players_count.editable = false
		if _enable_teams.is_connected("toggled", self, "_set_teams_enabled"):
			_enable_teams.disconnect("toggled", self, "_set_teams_enabled")
		if _teams_count.is_connected("value_changed", self, "_set_teams_count"):
			_teams_count.disconnect("value_changed", self, "_set_teams_count")
		if _players_count.is_connected("value_changed", self, "_set_players_count"):
			_players_count.disconnect("value_changed", self, "_set_players_count")


func _set_teams_enabled(enable: bool):
	_enable_teams.rset("pressed", enable)


func _set_teams_count(count: float):
	_teams_count.rset("value", count)


func _set_players_count(count: float):
	_players_count.rset("value", count)
