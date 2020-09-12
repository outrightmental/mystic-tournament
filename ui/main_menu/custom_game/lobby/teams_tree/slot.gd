class_name Slot
extends Node


signal id_changed(previous, current)

const EMPTY_SLOT = 0

var id: int = EMPTY_SLOT

var _tree_item: TreeItem


func _init(tree_item: TreeItem) -> void:
	_tree_item = tree_item
	_update_text()


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_tree_item.free()
		pass


func set_id(value: int) -> void:
	if id == value:
		return

	var previous_id: int = id
	id = value
	_update_text()

	emit_signal("id_changed", previous_id, id)


func _update_text() -> void:
	match id:
		EMPTY_SLOT:
			_tree_item.set_text(0, "Empty slot")
		_:
			_tree_item.set_text(0, str(id)) # TODO: Use nickname here
