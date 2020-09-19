extends PanelContainer


signal create_requested
signal join_requested(address, port)

onready var _direct_connect_dialog: DirectConnectDialog = $DirectConnectDialog


func _emit_create_request() -> void:
	emit_signal("create_requested")


func _emit_direct_join_request() -> void:
	emit_signal("join_requested", _direct_connect_dialog.address, _direct_connect_dialog.port)
