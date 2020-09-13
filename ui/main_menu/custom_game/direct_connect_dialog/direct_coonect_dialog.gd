extends ConfirmationDialog


signal connection_confirmed(address, port)


onready var _address_edit: LineEdit = $Grid/AddressEdit
onready var _port_spin: SpinBox = $Grid/PortSpin


func _confirm_connection() -> void:
	emit_signal("connection_confirmed", _address_edit.text, int(_port_spin.value))
	hide()
