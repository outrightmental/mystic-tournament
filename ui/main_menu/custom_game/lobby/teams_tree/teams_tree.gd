class_name TeamsTree
extends Tree


var _players_in_team: int = 1


func _ready():
	# Create root
	# warning-ignore:return_value_discarded
	create_item()
	set_teams_count(2)


func set_enable_teams(_enable: bool) -> void:
	# TODO: Implement logic
	pass


func set_teams_count(count: int) -> void:
	var root: TreeItem = get_root()
	var teams: Array = _get_children(root)
	if teams.size() < count:
		for team_index in range(teams.size(), count):
			_create_team(root, team_index)
	else:
		for team_index in range(count, teams.size()):
			teams[team_index].free()


func set_players_in_team(count: int) -> void:
	for team in _get_children(get_root()):
		var slots: Array = _get_children(team)
		if slots.size() < count:
			for _slot_index in range(slots.size(), count):
				_create_slot(team)
		else:
			for _slot_index in range(count, slots.size()):
				slots[_slot_index].free()


func _create_team(root: TreeItem, team_index: int) -> void:
	var team: TreeItem = create_item(root)
	team.set_text(0, "Team %d (0/%d)" % [team_index, _players_in_team])
	for _index in range(_players_in_team):
		_create_slot(team)


func _create_slot(team: TreeItem) -> void:
	var slot: TreeItem = create_item(team)
	slot.set_text(0, "Empty slot")


func _get_children(parent: TreeItem) -> Array:
	var children := Array()
	# This function has a very strange name, since it returns not children, but only the first child.
	var child: TreeItem = parent.get_children()
	while child != null:
		children.push_back(child)
		child = child.get_next()
	return children
