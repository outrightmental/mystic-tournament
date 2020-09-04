class_name ServerSettings
extends PanelContainer


onready var enable_teams: CheckBox = $VBox/EnableTeams
onready var teams_count: SpinBox = $VBox/TeamsCount/SpinBox
onready var players_count: SpinBox = $VBox/PlayersCount/SpinBox


func _ready():
	set_editable(false)

	# Allow to sync server configuration over network
	enable_teams.rset_config("pressed", MultiplayerAPI.RPC_MODE_PUPPET)
	teams_count.rset_config("value", MultiplayerAPI.RPC_MODE_PUPPET)
	players_count.rset_config("value", MultiplayerAPI.RPC_MODE_PUPPET)


func set_editable(editable: bool):
	if editable:
		enable_teams.disabled = false
		teams_count.editable = true
		players_count.editable = true
	else:
		enable_teams.disabled = true
		teams_count.editable = false
		players_count.editable = false
