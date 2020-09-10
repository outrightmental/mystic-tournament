class_name TeamsTree
extends Tree


enum SlotType {
	COMPUTER = -1,
	EMPTY_SLOT,
	HOST, # This and all next numbers correspond to player IDs (host is 1)
}

const _team_index: String = "team_index"
const _team_players: String = "team_players"
const _slot_value: String = "slot_type"

puppet var _teams_enabled: bool = true
puppet var _players_count: int = 1
puppet var _teams_count: int = 2
puppet var _players_in_team: int = 1


func _ready():
	# warning-ignore:return_value_discarded
	create_item() # Create root
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_sync_connected_peer")


func create() -> void:
	if _teams_enabled:
		_update_teams_count()
	else:
		_update_players_count()


func clear() -> void:
	var children: Array = _get_children(get_root())
	_free_array(children, 0, children.size())


func set_teams_enabled(_enable: bool) -> void:
	if _teams_enabled == _enable:
		return

	_teams_enabled = _enable
	var root: TreeItem = get_root()
	if _teams_enabled:
		var child: TreeItem = root.get_children()
		assert(child.get_next() == null, "Root should contain only a single child with all players")
		child.free()
		_update_teams_count()
	else:
		var teams: Array = _get_children(root)
		_free_array(teams, 1, teams.size()) # Remove all teams except first
		teams.front().set_text(0, "Players")
		_update_players_count()


func set_players_count(count: int) -> void:
	_players_count = count
	if !_teams_enabled:
		_update_players_count()


func set_teams_count(count: int) -> void:
	_teams_count = count
	if _teams_enabled:
		_update_teams_count()


func set_players_in_team(count: int) -> void:
	_players_in_team = count
	if _teams_enabled:
		_update_players_in_team_count()


puppet func _update_players_count() -> void:
	assert(!_teams_enabled, "Should be called only when teams disabled")
	var players: TreeItem = get_root().get_children()
	var slots: Array = _get_children(players)
	if slots.size() > _players_count:
		_free_array(slots, _players_count, slots.size())
		return

	for _index in range(slots.size(), _players_count):
		var slot: TreeItem = create_item(players)
		_set_slot(slot, SlotType.EMPTY_SLOT)


puppet func _update_teams_count() -> void:
	assert(_teams_enabled, "Should be called only when teams enabled")
	var root: TreeItem = get_root()
	var teams: Array = _get_children(root)
	if teams.size() > _teams_count:
		_free_array(teams, _teams_count, teams.size())
		return

	for index in range(teams.size(), _teams_count):
		var team: TreeItem = create_item(root)
		team.set_meta(_team_index, index)
		team.set_meta(_team_players, 0)
		for _slot_index in range(_players_in_team):
			var slot: TreeItem = create_item(team)
			if index == 0 && _slot_index == 0:
				_set_slot(slot, 1) # Set host
				team.set_meta(_team_players, 1)
			else:
				_set_slot(slot, SlotType.EMPTY_SLOT)
		_update_team_text(team)


func _update_players_in_team_count() -> void:
	assert(_teams_enabled, "Should be called only when teams enabled")
	for team in _get_children(get_root()):
		var slots: Array = _get_children(team)
		if slots.size() > _players_in_team:
			_free_array(slots, _players_in_team, slots.size())
		else:
			for _index in range(slots.size(), _players_in_team):
				var slot: TreeItem = create_item(team)
				_set_slot(slot, SlotType.EMPTY_SLOT)
		_update_team_text(team)


func _sync_connected_peer(id: int) -> void:
	if !get_tree().is_network_server():
		return
	
	rset_id(id, "_teams_enabled", _teams_enabled)
	rset_id(id, "_players_count", _players_count)
	rset_id(id, "_teams_count", _teams_count)
	rset_id(id, "_players_in_team", _players_in_team)
	if _teams_enabled:
		rpc_id(id, "_update_teams_count")
	else:
		rpc_id(id, "_update_players_count")


func _update_team_text(team: TreeItem) -> void:
	team.set_text(0, "Team %d (%d/%d)" % [team.get_meta(_team_index), team.get_meta(_team_players), _players_in_team])


func _set_slot(slot: TreeItem, value: int) -> void:
	slot.set_meta(_slot_value, value)
	match value:
		SlotType.COMPUTER:
			slot.set_text(0, "Computer")
		SlotType.EMPTY_SLOT:
			slot.set_text(0, "Empty slot")
		_:
			slot.set_text(0, str(value)) # TODO: Get nickname


func _get_children(parent: TreeItem) -> Array:
	var children := Array()
	# This function has a very strange name, since it returns not children, but only the first child.
	var child: TreeItem = parent.get_children()
	while child != null:
		children.push_back(child)
		child = child.get_next()
	return children


func _free_array(array: Array, begin: int, end: int) -> void:
	for index in range(begin, end):
		array[index].free()
