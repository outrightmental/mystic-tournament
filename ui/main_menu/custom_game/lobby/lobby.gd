class_name Lobby
extends PanelContainer
# Represents the lobby and manages connections to it


signal joined
signal join_failed
signal create_failed
signal leaved
signal configurable_changed(configurable)

var _configurable: bool
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


func create(teams_count: int, slots_count: int) -> void:
	# TODO: Display all addresses here
	_addresses_edit.text = IP.get_local_addresses().front()
	_set_configurable(true)
	teams_tree.create(teams_count, slots_count)


func join(address: String, port: int) -> int:
	var result: int = _peer.create_client(address, port)
	if result == OK:
		get_tree().network_peer = _peer

	return result


func close_connection() -> void:
	_peer.close_connection()
	get_tree().network_peer = null


func leave() -> void:
	if _configurable:
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
	_set_configurable(false)


func _close():
	close_connection()
	teams_tree.clear()
	emit_signal("leaved")


func _on_successful_connection() -> void:
	_set_configurable(false)
	emit_signal("joined")


func _on_failed_connection() -> void:
	get_tree().network_peer = null
	emit_signal("join_failed")	


func _set_configurable(configurable: bool) -> void:
	if configurable == _configurable:
		return
	_configurable = configurable
	_port_spin.editable = _configurable
	_server_name_edit.editable = _configurable
	emit_signal("configurable_changed", _configurable)
