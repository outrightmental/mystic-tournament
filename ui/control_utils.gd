class_name ControlUtils


# Disables input events processing when popup is hidden
static func disable_input_when_hidden(popup: Popup) -> void:
	popup.set_process_input(false)
	# warning-ignore:return_value_discarded
	popup.connect("about_to_show", popup, "set_process_input", [true])
	# warning-ignore:return_value_discarded
	popup.connect("popup_hide", popup, "set_process_input", [false])
