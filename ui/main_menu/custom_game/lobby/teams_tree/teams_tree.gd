class_name TeamsTree
extends Tree


puppet var _teams_enabled: bool = true
puppet var _slots_count: int = 1
puppet var _teams_count: int = 2
puppet var _slots_in_team: int = 1

puppet var _teams: Array


func _ready():
	# warning-ignore:return_value_discarded
	create_item() # Create root
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_sync_connected_peer")


func create() -> void:
	if _teams_enabled:
		_apply_teams_count()
	else:
		_apply_slots_count()


func clear() -> void:
	Utils.truncate_and_free(_teams, 0)


func set_teams_enabled(enable: bool) -> void:
	if _teams_enabled == enable:
		return

	_teams_enabled = enable
	if _teams_enabled:
		assert(_teams.size() == 1, "Should be only one team with all slots")
		_teams.front().reset(1, _slots_in_team)
		_apply_teams_count()
	else:
		Utils.truncate_and_free(_teams, 1) # Remove all teams except first
		_teams.front().reset(-1, _slots_count)
		_apply_slots_count()


func set_slots_count(count: int) -> void:
	_slots_count = count
	if !_teams_enabled:
		_apply_slots_count()


func set_teams_count(count: int) -> void:
	_teams_count = count
	if _teams_enabled:
		_apply_teams_count()


func set_slots_in_team(count: int) -> void:
	_slots_in_team = count
	if _teams_enabled:
		_apply_slots_in_team_count()


puppet func _apply_slots_count() -> void:
	assert(!_teams_enabled, "Should be called only when teams disabled")
	_teams.front().set_slots_count(_slots_count)


puppet func _apply_teams_count() -> void:
	assert(_teams_enabled, "Should be called only when teams enabled")
	if _teams.size() > _teams_count:
		Utils.truncate_and_free(_teams, _teams_count)
		return

	for index in range(_teams.size(), _teams_count):
		_teams.append(Team.new(self, index + 1, _slots_in_team))


func _apply_slots_in_team_count() -> void:
	assert(_teams_enabled, "Should be called only when teams enabled")
	for team in _teams:
		team.set_slots_count(_slots_in_team)


func _sync_connected_peer(id: int) -> void:
	if !get_tree().is_network_server():
		return
	
	rset_id(id, "_teams_enabled", _teams_enabled)
	rset_id(id, "_slots_count", _slots_count)
	rset_id(id, "_teams_count", _teams_count)
	rset_id(id, "_slots_in_team", _slots_in_team)
	if _teams_enabled:
		rpc_id(id, "_apply_teams_count")
	else:
		rpc_id(id, "_apply_slots_count")
