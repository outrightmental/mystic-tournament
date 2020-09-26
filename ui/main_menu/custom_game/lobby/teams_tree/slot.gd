class_name Slot
extends Node
# Wrapper around TreeItem to represent team slot in Tree
# It also extends Node to allow RPC synchronization

signal id_changed(previous, current)

enum {
	EMPTY_SLOT = 0,
	HOST = 1,
	# All values ​​after 1 corresponds to the player's unique identifier.
}

var id: int = -1 setget set_id

var _tree_item: TreeItem


# Team do not have a type to avoid cycling dependency issues
# Maybe will be fixed: https://github.com/godotengine/godot/pull/38118
func _init(team, slot_id: int) -> void:
	team.add_child(self)
	_tree_item = team.get_parent().create_item(team.get_tree_item())
	self.id = slot_id


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
