class_name Lobby
extends PanelContainer
# Represents the lobby and manages connections to it


signal joined
signal leaved
signal configurable_changed(configurable)

var _configurable: bool

onready var teams_tree: TeamsTree = $VBox/TeamsTree
onready var _error_dialog: ErrorDialog = $ErrorDialog
onready var _connection_dialog: ConnectionDialog = $ConnectionDialog
onready var _leave_dialog: ConfirmationDialog = $LeaveDialog
onready var _server_name_edit: LineEdit = $VBox/Grid/ServerNameEdit
onready var _addresses_edit: LineEdit = $VBox/Grid/AddressesEdit
onready var _port_spin: SpinBox = $VBox/Grid/PortSpin


func create() -> void:
	# TODO: Display all addresses here
	_addresses_edit.text = IP.get_local_addresses().front()
	_set_configurable(true)
	teams_tree.create()


func join(address: String, port: int) -> void:
	var peer: = NetworkedMultiplayerENet.new()
	var result: int = peer.create_client(address, port)
	if result != OK:
		_error_dialog.show_error("Unable to create connection")
		return

	_connection_dialog.show_connecting(address, port)
	get_tree().network_peer = peer

	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_process_successful_join", [], CONNECT_ONESHOT)
	# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_process_failed_join", [], CONNECT_ONESHOT)


func leave() -> void:
	if _configurable:
		# Just close if the lobby is not configured
		_close()
	else:
		_leave_dialog.popup_centered()


func _close():
	get_tree().network_peer = null
	_set_configurable(false)
	teams_tree.clear()
	emit_signal("leaved")


func _cancel_join() -> void:
	get_tree().disconnect("connected_to_server", self, "_process_successful_join")
	get_tree().disconnect("connection_failed", self, "_process_failed_join")
	get_tree().network_peer = null


func _process_successful_join() -> void:
	# Stop listening for failed connection
	get_tree().disconnect("connection_failed", self, "_process_failed_join")

	_connection_dialog.hide()
	_set_configurable(false)
	set_process_unhandled_input(true)
	emit_signal("joined")


func _process_failed_join() -> void:
	# Stop listening for success connection
	get_tree().disconnect("connected_to_server", self, "_process_successful_join")
	
	get_tree().network_peer = null
	_connection_dialog.hide()
	_error_dialog.show_error("Unable to join lobby")


func _confirm_creation() -> void:
	var peer: = NetworkedMultiplayerENet.new()
	var result: int = peer.create_server(int(_port_spin.value))
	if result != OK:
		_error_dialog.show_error("Unable to create server")
		return

	get_tree().network_peer = peer
	_set_configurable(false)


func _set_configurable(configurable: bool) -> void:
	if configurable == _configurable:
		return
	_configurable = configurable
	_port_spin.editable = _configurable
	_server_name_edit.editable = _configurable
	emit_signal("configurable_changed", _configurable)
