class_name Team
extends Node
# Wrapper around TreeItem to represent team in Tree
# It also extends Node to allow RPC synchronization


signal filled_changed(is_full)

const NO_TEAM_NUMBER: int = -1

var team_number: int setget set_team_number

var _tree_item: TreeItem
var _slots: Array
var _used_slots_count: int


func _init(tree: Tree, number: int, slots) -> void:
	tree.add_child(self, true)
	_tree_item = tree.create_item(tree.get_root())

	# TODO: Check if this setter call text update twice in 4.0
	team_number = number

	if typeof(slots) == TYPE_INT_ARRAY:
		_create_slots_from_ids(slots)
	else:
		resize(slots)


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_tree_item.free()


func set_team_number(number: int) -> void:
	team_number = number
	_update_text()


func resize(count: int) -> void:
	if _slots.size() == count:
		return

	if _slots.size() < count:
		for _slot_index in range(_slots.size(), count):
			_create_slot(Slot.EMPTY_SLOT)
	else:
		Utils.truncate_and_free(_slots, count)
	_update_text()


func size() -> int:
	return _slots.size()


func get_slot(slot_index: int) -> Slot:
	return _slots[slot_index]


func get_slot_ids() -> PoolIntArray:
	var array: PoolIntArray = []
	for slot in _slots:
		array.append(slot.id)
	return array


func get_tree_item() -> TreeItem:
	return _tree_item


func is_full() -> bool:
	return _slots.size() == _used_slots_count


func _update_used_slots(previous_slot_id: int, current_slot_id: int) -> void:
	if previous_slot_id == Slot.EMPTY_SLOT and current_slot_id != Slot.EMPTY_SLOT:
		_used_slots_count += 1
		if is_full():
			emit_signal("filled_changed", true)
	elif previous_slot_id != Slot.EMPTY_SLOT and current_slot_id == Slot.EMPTY_SLOT:
		if is_full():
			emit_signal("filled_changed", false)
		_used_slots_count -= 1

	_update_text()


func _create_slots_from_ids(slots: PoolIntArray) -> void:
	for id in slots:
		_create_slot(id)
	_update_text()


func _create_slot(id: int) -> void:
	var slot := Slot.new(self, id)
	# warning-ignore:return_value_discarded
	slot.connect("id_changed", self, "_update_used_slots")
	_slots.append(slot)
	if id != Slot.EMPTY_SLOT:
		_used_slots_count += 1


func _update_text() -> void:
	if team_number == NO_TEAM_NUMBER:
		_tree_item.set_text(0, "Players (%d/%d)" % [_used_slots_count, _slots.size()])
	else:
		_tree_item.set_text(0, "Team %d (%d/%d)" % [team_number, _used_slots_count, _slots.size()])
