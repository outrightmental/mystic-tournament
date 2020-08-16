class_name ConnectionDialog
extends WindowDialog
# Dialog to display incoming connection


signal canceled

onready var _label: Label = $HBox/Label


func show_connecting(server_name: String) -> void:
	_label.text = "Connecting to %s..." % server_name
	popup_centered()


func _cancel() -> void:
	hide()
	emit_signal("canceled")
