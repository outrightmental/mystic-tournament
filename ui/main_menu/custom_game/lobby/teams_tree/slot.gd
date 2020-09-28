class_name Slot
extends TreeItemWrapper
# Represents Slot in TeamsTree
# Contains text based on the given ID
# ID can be a peer ID or a special number that represents empty slot / computer


signal id_changed(slot, previous_id)

enum {
	EMPTY_SLOT = 0,
	HOST = 1,
	# All values ​​after 1 corresponds to the player's unique identifier.
}

puppetsync var id: int = -1 setget set_id


# Team do not have a Team type to avoid cycling dependency issues
# Maybe will be fixed: https://github.com/godotengine/godot/pull/38118
func _init(team: Node, slot_id: int) -> void:
	team.add_child(self, true)
	_tree_item = team.get_parent().create_item(team.get_tree_item())
	self.id = slot_id


puppetsync func set_id(value: int) -> void:
	if id == value:
		return

	var previous_id: int = id
	id = value

	_update_text()
	emit_signal("id_changed", self, previous_id)


func _update_text() -> void:
	match id:
		EMPTY_SLOT:
			_tree_item.set_text(0, "Empty slot")
		_:
			_tree_item.set_text(0, str(id)) # TODO: Use nickname here
