class_name ServerSettings
extends PanelContainer


onready var teams_enabled: CheckBox = $VBox/TeamsEnabled
onready var slots_count: SpinBox = $VBox/SlotsCount/SpinBox
onready var teams_count: SpinBox = $VBox/TeamsCount/SpinBox
onready var slots_in_team: SpinBox = $VBox/SlotsInTeamCount/SpinBox
onready var _slots_count_box: HBoxContainer = $VBox/SlotsCount
onready var _teams_count_box: HBoxContainer = $VBox/TeamsCount
onready var _slots_in_team_box: HBoxContainer = $VBox/SlotsInTeamCount


func _ready():
	set_editable(false)
	_set_teams_enabled(teams_enabled.pressed)

	# Allow to sync server configuration over network
	teams_enabled.rset_config("pressed", MultiplayerAPI.RPC_MODE_PUPPET)
	slots_count.rset_config("value", MultiplayerAPI.RPC_MODE_PUPPET)
	teams_count.rset_config("value", MultiplayerAPI.RPC_MODE_PUPPET)
	slots_in_team.rset_config("value", MultiplayerAPI.RPC_MODE_PUPPET)
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_send_settings_to_peer")


func set_editable(editable: bool):
	teams_enabled.disabled = !editable
	slots_count.editable = editable
	teams_count.editable = editable
	slots_in_team.editable = editable


func _set_teams_enabled(enabled: bool) -> void:
	_slots_count_box.visible = !enabled
	_teams_count_box.visible = enabled
	_slots_in_team_box.visible = enabled

	# Update values
	if enabled:
		slots_in_team.value = ceil(slots_count.value / teams_count.value)
	else:
		slots_count.value = slots_in_team.value * teams_count.value


func _send_settings_to_peer(id: int) -> void:
	if !get_tree().is_network_server():
		return
	teams_enabled.rset_id(id, "pressed", teams_enabled.pressed)
	slots_count.rset_id(id, "value", slots_count.value)
	teams_count.rset_id(id, "value", teams_count.value)
	slots_in_team.rset_id(id, "value", slots_in_team.value)
