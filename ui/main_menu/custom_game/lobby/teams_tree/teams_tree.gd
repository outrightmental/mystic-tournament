class_name TeamsTree
extends Tree


var _teams_enabled: bool = true
var _players_count: int = 1
var _teams_count: int = 2
var _players_in_team: int = 1


func _ready():
	# warning-ignore:return_value_discarded
	create_item() # Create root
	set_teams_count(2)


func set_teams_enabled(_enable: bool) -> void:
	if _teams_enabled == _enable:
		return

	_teams_enabled = _enable
	var root: TreeItem = get_root()
	if _teams_enabled:
		var child: TreeItem = root.get_children()
		assert(child.get_next() == null, "Root should contain only a single child with all players")
		child.free()
		set_teams_count(_teams_count)
	else:
		for team in _get_children(root):
			team.free()
		var players: TreeItem = create_item(root)
		players.set_text(0, "Players")
		for index in range(_players_count):
			_create_slot(players, index)


func set_players_count(count: int) -> void:
	_players_count = count
	if _teams_enabled:
		return

	_set_children_count(get_root().get_children(), "_create_slot", count)


func set_teams_count(count: int) -> void:
	_teams_count = count
	if !_teams_enabled:
		return

	_set_children_count(get_root(), "_create_team", count)


func set_players_in_team(count: int) -> void:
	_players_in_team = count
	if !_teams_enabled:
		return

	for team in _get_children(get_root()):
		_set_children_count(team, "_create_slot", count)


func _set_children_count(parent: TreeItem, create_func: String, count: int) -> void:
	var children: Array = _get_children(parent)
	if children.size() < count:
		for index in range(children.size(), count):
			call(create_func, parent, index)
	else:
		for index in range(count, children.size()):
			children[index].free()


func _create_team(root: TreeItem, team_index: int) -> void:
	var team: TreeItem = create_item(root)
	team.set_text(0, "Team %d (0/%d)" % [team_index, _players_in_team])
	for index in range(_players_in_team):
		_create_slot(team, index)


func _create_slot(team: TreeItem, slot_index: int) -> void:
	var slot: TreeItem = create_item(team)
	slot.set_text(0, "Empty slot %d" % slot_index)


func _get_children(parent: TreeItem) -> Array:
	var children := Array()
	# This function has a very strange name, since it returns not children, but only the first child.
	var child: TreeItem = parent.get_children()
	while child != null:
		children.push_back(child)
		child = child.get_next()
	return children
