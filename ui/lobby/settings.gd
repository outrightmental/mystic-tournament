extends PanelContainer


func _ready():
	# Sync server configuration over network
	$VBox/EnableTeams.rset_config("pressed", MultiplayerAPI.RPC_MODE_PUPPET)
	$VBox/TeamsCount/SpinBox.rset_config("value", MultiplayerAPI.RPC_MODE_PUPPET)
	$VBox/PlayersCount/SpinBox.rset_config("value", MultiplayerAPI.RPC_MODE_PUPPET)

	# Server configuration available only for server
	if get_tree().is_network_server():
		# warning-ignore:return_value_discarded
		$VBox/EnableTeams.connect("toggled", self, "_enable_teams")
		# warning-ignore:return_value_discarded
		$VBox/TeamsCount/SpinBox.connect("value_changed", self, "_set_teams_count")
		# warning-ignore:return_value_discarded
		$VBox/PlayersCount/SpinBox.connect("value_changed", self, "_set_players_count")
	else:
		$VBox/EnableTeams.disabled = true
		$VBox/TeamsCount/SpinBox.editable = false
		$VBox/PlayersCount/SpinBox.editable = false


func _enable_teams(enable: bool):
	$VBox/EnableTeams.rset("pressed", enable)


func _set_teams_count(count: float):
	$VBox/TeamsCount/SpinBox.rset("value", count)


func _set_players_count(count: float):
	$VBox/PlayersCount/SpinBox.rset("value", count)
