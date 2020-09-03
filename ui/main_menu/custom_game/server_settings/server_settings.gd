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
	else:
		_enable_teams.disabled = true
		_teams_count.editable = false
		_players_count.editable = false
