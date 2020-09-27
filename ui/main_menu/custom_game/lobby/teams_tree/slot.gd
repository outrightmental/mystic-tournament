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
enum {
	JOIN_BUTTON
}

puppetsync var id: int = -1 setget set_id

var _tree_item: TreeItem


# Team do not have a type to avoid cycling dependency issues
# Maybe will be fixed: https://github.com/godotengine/godot/pull/38118
func _init(team, slot_id: int) -> void:
	team.add_child(self, true)
	_tree_item = team.get_parent().create_item(team.get_tree_item())
	self.id = slot_id

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_tree_item.free()
		pass


puppetsync func set_id(value: int) -> void:
	if id == value:
		return

	var previous_id: int = id
	id = value

	if get_tree().get_network_unique_id() == id:
		_remove_button(JOIN_BUTTON)
	else:
		_add_button(JOIN_BUTTON)

	_update_text()
	emit_signal("id_changed", previous_id, id)


func get_tree_item() -> TreeItem:
	return _tree_item


func _add_button(button_type: int) -> void:
	# TODO: Replace with icon
	var temp_image = ImageTexture.new()
	temp_image.create(15, 15, Image.FORMAT_BPTC_RGBA)

	_tree_item.add_button(button_type, temp_image, 0, false, "Join")


func _remove_button(button_type: int) -> void:
	if _tree_item.get_button_count(JOIN_BUTTON) == 1:
		_tree_item.erase_button(button_type, 0)


func _update_text() -> void:
	match id:
		EMPTY_SLOT:
			_tree_item.set_text(0, "Empty slot")
		_:
			_tree_item.set_text(0, str(id)) # TODO: Use nickname here
