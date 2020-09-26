class_name TeamsTree
extends Tree


signal filled_changed(is_full)

var _teams: Array
var _teams_full: bool


func _ready():
	# warning-ignore:return_value_discarded
	create_item() # Create root
	# warning-ignore:return_value_discarded
	connect("button_pressed", self, "_on_slot_button_pressed")


func create(teams_count: int, slots_count: int) -> void:
	assert(_teams.empty(), "You should clear first")
	assert(slots_count >= 1, "The number of slots cannot be less than 1")
	assert(teams_count >= 1, "The number of teams cannot be less than 1")
	for index in range(teams_count):
		if index == 0:
			# First team should contain host
			var slots: PoolIntArray = [Slot.HOST]
			slots.resize(slots_count) # Will filled with zeroes that corresponds to EMPTY_SLOT
			_create_team(slots)
		else:
			_create_team(slots_count)


func clear() -> void:
	Utils.truncate_and_free(_teams, 0)


func set_slots_count(count: int) -> void:
	for team in _teams:
		team.resize(count)


func set_teams_count(count: int) -> void:
	if count == 0:
		_teams.front().team_number = Team.NO_TEAM_NUMBER
		Utils.truncate_and_free(_teams, 1) # Remove all teams except one
		return

	_teams.front().team_number = 1
	if _teams.size() > count:
		Utils.truncate_and_free(_teams, count)
		return

	for _index in range(_teams.size(), count):
		_create_team(_teams.front().size())


func add_connected_player(id: int) -> void:
	if not get_tree().is_network_server():
		return

	# Add player to the first empty slot
	var slot: Slot = _find_slot(Slot.EMPTY_SLOT)
	assert(slot != null, "There is no empty slots to add a new player")
	slot.id = id

	# Send all data to new player
	for team in _teams:
		rpc_id(id, "_create_team", team.get_slot_ids())


puppet func _create_team(slots) -> void:
	var team := Team.new(self, _teams.size() + 1, slots)
	if get_tree().has_network_peer() and get_tree().is_network_server():
		# warning-ignore:return_value_discarded
		team.connect("filled_changed", self, "_check_if_filled_changed")
	_teams.append(team)


master func _join_slot(team_index: int, slot_index: int) -> void:
	var previous_slot: Slot = _find_slot(get_tree().get_rpc_sender_id())
	var new_slot = _teams[team_index].get_slot(slot_index)
	assert(new_slot.id == Slot.EMPTY_SLOT)
	new_slot.rset("id", previous_slot.id)
	previous_slot.rset("id", Slot.EMPTY_SLOT)


func _on_slot_button_pressed(item: TreeItem, column: int, _button_idx: int) -> void:
	var item_indexes: PoolIntArray = _get_slot_item_indexes(item)
	assert(item_indexes.size() == 2, "Unable to corresponding TreeItem")
	match column:
		Slot.JOIN_BUTTON:
			rpc("_join_slot", item_indexes[0], item_indexes[1])


func _check_if_filled_changed() -> void:
	if _teams_full == _is_teams_full():
		return

	_teams_full = not _teams_full
	emit_signal("filled_changed", _teams_full)


func _find_slot(id: int) -> Slot:
	for team in _teams:
		for slot_index in range(team.size()):
			var slot: Slot = team.get_slot(slot_index)
			if slot.id == id:
				return slot
	return null


func _get_slot_item_indexes(item: TreeItem) -> PoolIntArray:
	for team_index in range(_teams.size()):
		var team: Team = _teams[team_index]
		for slot_index in range(team.size()):
			if team.get_slot(slot_index).get_tree_item() == item:
				return PoolIntArray([team_index, slot_index])
	return PoolIntArray()


func _is_teams_full() -> bool:
	for team in _teams:
		if not team.is_full():
			return false
	return true
