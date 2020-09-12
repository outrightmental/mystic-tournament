class_name Team
extends Node


var _tree: Tree
var _tree_item: TreeItem
var _slots: Array
var _team_number: int # -1 means that this is a single team that contains all slots
var _used_slots: int = 0
var _listen_slot_changes = true


func _init(tree: Tree, team_number: int, slots_count: int) -> void:
	_tree = tree
	_tree_item = _tree.create_item(_tree.get_root())
	reset(team_number, slots_count)


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_tree_item.free()
		pass


func reset(team_number: int, slots_count: int) -> void:
	_team_number = team_number
	set_slots_count(slots_count)


func set_slots_count(count: int) -> void:
	if _slots.size() < count:
		for _slot_index in range(_slots.size(), count):
			var slot := Slot.new(_tree.create_item(_tree_item))
			# warning-ignore:return_value_discarded
			slot.connect("id_changed", self, "_update_used_slots")
			_slots.append(slot)
	else:
		Utils.truncate_and_free(_slots, count)
	_update_text()


func set_slot_id(slot_index: int, id: int) -> void:
	 _slots[slot_index].id = id


func set_slot_ids(ids: Array) -> void:
	assert(ids.size() == _slots.size(), "The IDs array must be the same size as the slots array")
	_listen_slot_changes = false
	for index in range(_slots.size()):
		_slots[index].id = ids[index]
	_listen_slot_changes = true
	_update_text()


func _update_used_slots(previous_slot_id: int, current_slot_id: int) -> void:
	if previous_slot_id == Slot.EMPTY_SLOT and current_slot_id != Slot.EMPTY_SLOT:
		_used_slots += 1
	elif previous_slot_id != Slot.EMPTY_SLOT and current_slot_id == Slot.EMPTY_SLOT:
		_used_slots -= 1

	if _listen_slot_changes:
		_update_text()


func _update_text() -> void:
	if _team_number == -1:
		_tree_item.set_text(0, "Players (%d/%d)" % [_used_slots, _slots.size()])
	else:
		_tree_item.set_text(0, "Team %d (%d/%d)" % [_team_number, _used_slots, _slots.size()])
