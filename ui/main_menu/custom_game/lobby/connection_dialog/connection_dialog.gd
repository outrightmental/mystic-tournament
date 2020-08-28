class_name ConnectionDialog
extends WindowDialog
# Dialog to display incoming connection


signal canceled

onready var _label: Label = $HBox/Label


func show_connecting(address: String, port: int) -> void:
	_label.text = "Connecting to %s:%d" % [address, port]
	popup_centered()


func _cancel() -> void:
	hide()
	emit_signal("canceled")
