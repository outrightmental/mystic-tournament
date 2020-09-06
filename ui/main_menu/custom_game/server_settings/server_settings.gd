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
