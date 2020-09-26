class_name Lobby
extends PanelContainer
# Represents the lobby and manages connections to it


signal joined
signal join_failed
signal created
signal create_failed
signal server_disconnected
signal leaved

var _editable: bool
var _peer := NetworkedMultiplayerENet.new()

onready var teams_tree: TeamsTree = $VBox/TeamsTree
onready var _leave_dialog: ConfirmationDialog = $LeaveDialog
onready var _server_name_edit: LineEdit = $VBox/Grid/ServerNameEdit
onready var _addresses_edit: LineEdit = $VBox/Grid/AddressesEdit
onready var _port_spin: SpinBox = $VBox/Grid/PortSpin


func _init() -> void:
	# warning-ignore:return_value_discarded
	_peer.connect("connection_succeeded", self, "_on_successful_connection")
	# warning-ignore:return_value_discarded
	_peer.connect("connection_failed", self, "_on_failed_connection")
	# warning-ignore:return_value_discarded
	_peer.connect("server_disconnected", self, "_on_server_disconnected")


func _ready() -> void:
	# warning-ignore:return_value_discarded
	_peer.connect("peer_connected", teams_tree, "add_connected_player")
	# warning-ignore:return_value_discarded
	teams_tree.connect("filled_changed", _peer, "set_refuse_new_connections")


func create() -> void:
	# TODO: Display all addresses here
	_addresses_edit.text = IP.get_local_addresses().front()
	_set_editable(true)


func join(address: String, port: int) -> int:
	var result: int = _peer.create_client(address, port)
	if result == OK:
		get_tree().network_peer = _peer

	return result


func close_connection() -> void:
	_peer.close_connection()
	get_tree().network_peer = null


func leave() -> void:
	if _editable:
		# Just close if the lobby is not configured
		_close()
	else:
		_leave_dialog.popup_centered()


func _confirm_creation() -> void:
	var result: int = _peer.create_server(int(_port_spin.value))
	if result != OK:
		emit_signal("create_failed")
		return

	get_tree().network_peer = _peer
	_set_editable(false)
	emit_signal("created")


func _close():
	close_connection()
	teams_tree.clear()
	emit_signal("leaved")


func _on_successful_connection() -> void:
	_set_editable(false)
	emit_signal("joined")


func _on_failed_connection() -> void:
	get_tree().network_peer = null
	emit_signal("join_failed")


func _on_server_disconnected() -> void:
	get_tree().network_peer = null
	emit_signal("server_disconnected")


func _set_editable(editable: bool) -> void:
	if editable == _editable:
		return
	_editable = editable
	_port_spin.editable = _editable
	_server_name_edit.editable = _editable
