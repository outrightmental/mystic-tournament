class_name TeamsTree
extends Tree


puppet var _teams: Array


func _ready():
	# warning-ignore:return_value_discarded
	create_item() # Create root


func create(teams_count: int, slots_count: int) -> void:
	assert(_teams.empty(), "You should clear first")
	for team_number in range(teams_count):
		_teams.append(Team.new(self, team_number + 1, slots_count))


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

	for index in range(_teams.size(), count):
		_teams.append(Team.new(self, index + 1, _teams.front().size()))
