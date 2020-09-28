class_name TeamsTree
extends Tree


signal filled_changed(is_full)

var _teams: Array
var _teams_full: bool


func _ready():
	# warning-ignore:return_value_discarded
	create_item() # Create root
	# warning-ignore:return_value_discarded
	connect("button_pressed", self, "_on_button_pressed")


func create(teams_count: int, slots_count: int) -> void:
	assert(_teams.empty(), "You should clear first")
	assert(slots_count >= 1, "The number of slots cannot be less than 1")
	assert(teams_count >= 1, "The number of teams cannot be less than 1")

	for index in range(teams_count):
		if index == 0:
			# First team should contain host
			var slots: Array = [Slot.HOST] # Use array because of bug with resize in PoolIntArray (https://github.com/godotengine/godot/issues/31040)
			slots.resize(slots_count) # Will filled with zeroes that corresponds to EMPTY_SLOT
			_create_team(PoolIntArray(slots))
		else:
			_create_team(slots_count)


func clear() -> void:
	_truncate_teams(0)


func set_slots_count(count: int) -> void:
	if _teams.front().size() > count:
		for team in _teams:
			team.rpc("truncate", count)
		return

	for team in _teams:
		team.rpc("add_slots", count - team.size())


func set_teams_count(count: int) -> void:
	if count == 0:
		_teams.front().rset("team_number", Team.NO_TEAM_NUMBER)
		rpc("_truncate_teams", 1) # Remove all teams except one
		return

	_teams.front().team_number = 1
	if _teams.size() > count:
		rpc("_truncate_teams", count)
		return

	for _index in range(_teams.size(), count):
		rpc("_create_team", _teams.front().size())
		# Must be called on the server separately, as this function is also used
		# to send existing data to the connected client (therefore, cannot be marked as sync)
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
	if get_tree().is_network_server():
		# warning-ignore:return_value_discarded
		team.connect("filled_changed", self, "_check_if_filled_changed")
	_teams.append(team)


func _on_button_pressed(item: TreeItem, column: int, _button_idx: int) -> void:
	var item_indexes: PoolIntArray = _get_tree_item_indexes(item)
	assert(not item_indexes.empty(), "Unable to find corresponding TreeItem")
	match column:
		Team.JOIN_BUTTON:
			rpc("_join_team", item_indexes[0])


master func _join_team(team_index: int) -> void:
	var previous_slot: Slot = _find_slot(get_tree().get_rpc_sender_id())
	var new_slot = _teams[team_index].find_slot(Slot.EMPTY_SLOT)
	if new_slot == null:
		return
	new_slot.rset("id", previous_slot.id)
	previous_slot.rset("id", Slot.EMPTY_SLOT)


puppetsync func _truncate_teams(size: int) -> void:
	Utils.truncate_and_free(_teams, size)


func _check_if_filled_changed() -> void:
	if _teams_full == _is_teams_full():
		return

	_teams_full = not _teams_full
	emit_signal("filled_changed", _teams_full)


func _find_slot(id: int) -> Slot:
	for team in _teams:
		var slot: Slot = team.find_slot(id)
		if slot != null:
			return slot
	return null


func _get_tree_item_indexes(item: TreeItem) -> PoolIntArray:
	for team_index in range(_teams.size()):
		var team: Team = _teams[team_index]
		if team.get_tree_item() == item:
			return PoolIntArray([team_index])
		for slot_index in range(team.size()):
			if team.get_slot(slot_index).get_tree_item() == item:
				return PoolIntArray([team_index, slot_index])
	return PoolIntArray()


func _is_teams_full() -> bool:
	for team in _teams:
		if not team.is_full():
			return false
	return true
