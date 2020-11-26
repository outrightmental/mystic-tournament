extends TextureRect


onready var _key_label: Label = $KeyLabel


func set_display_action(action_index: int) -> void:
	var event = InputMap.get_action_list(PlayerController.ABILITY_ACTIONS[action_index]).front()
	if event is InputEventMouseButton:
		match event.button_index:
			BUTTON_LEFT:
				_key_label.text = "LMB"
			BUTTON_RIGHT:
				_key_label.text = "RMB"
	elif event is InputEventKey:
		_key_label.text = OS.get_scancode_string(event.scancode)
	else:
		assert("Unknown event type")
