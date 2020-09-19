class_name ErrorDialog
extends AcceptDialog


func show_error(error_text: String) -> void:
	dialog_text = error_text
	popup_centered()
