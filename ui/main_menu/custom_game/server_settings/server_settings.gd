class_name ServerSettings
extends PanelContainer


onready var teams_enabled: CheckBox = $VBox/TeamsEnabled
onready var players_count: SpinBox = $VBox/PlayersCount/SpinBox
onready var teams_count: SpinBox = $VBox/TeamsCount/SpinBox
onready var players_in_team: SpinBox = $VBox/PlayersInTeamCount/SpinBox
onready var _players_count_box: HBoxContainer = $VBox/PlayersCount
onready var _teams_count_box: HBoxContainer = $VBox/TeamsCount
onready var _players_in_team_box: HBoxContainer = $VBox/PlayersInTeamCount


func _ready():
	set_editable(false)
	_set_teams_enabled(teams_enabled.pressed)

	# Allow to sync server configuration over network
	teams_enabled.rset_config("pressed", MultiplayerAPI.RPC_MODE_PUPPET)
	players_count.rset_config("value", MultiplayerAPI.RPC_MODE_PUPPET)
	teams_count.rset_config("value", MultiplayerAPI.RPC_MODE_PUPPET)
	players_in_team.rset_config("value", MultiplayerAPI.RPC_MODE_PUPPET)
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_send_settings_to_peer")


func set_editable(editable: bool):
	teams_enabled.disabled = !editable
	players_count.editable = editable
	teams_count.editable = editable
	players_in_team.editable = editable


func _set_teams_enabled(enabled: bool) -> void:
	_players_count_box.visible = !enabled
	_teams_count_box.visible = enabled
	_players_in_team_box.visible = enabled

	# Update values
	if enabled:
		players_in_team.value = ceil(players_count.value / teams_count.value)
	else:
		players_count.value = players_in_team.value * teams_count.value


func _send_settings_to_peer(id: int) -> void:
	if !get_tree().is_network_server():
		return
	teams_enabled.rset_id(id, "pressed", teams_enabled.pressed)
	players_count.rset_id(id, "value", players_count.value)
	teams_count.rset_id(id, "value", teams_count.value)
	players_in_team.rset_id(id, "value", players_in_team.value)
