extends PanelContainer
# Represents the lobby and manages connections to it


signal joined
signal configurable_changed(configurable)

var _configurable: bool = false

onready var _error_dialog: ErrorDialog = $ErrorDialog
onready var _connection_dialog: ConnectionDialog = $ConnectionDialog
onready var _leave_dialog: ConfirmationDialog = $LeaveDialog
onready var _server_name_edit: LineEdit = $VBox/Grid/ServerNameEdit
onready var _addresses_edit: LineEdit = $VBox/Grid/AddressesEdit
onready var _port_spin: SpinBox = $VBox/Grid/PortSpin


func _ready():
	set_process_unhandled_input(false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		_leave_dialog.popup_centered()


func configure():
	show()
	# TODO: Display all addresses here
	_addresses_edit.text = IP.get_local_addresses().front()
	_set_configurable(true)


func join(address: String, port: int):
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


func _cancel_join() -> void:
	get_tree().disconnect("connected_to_server", self, "_process_successful_join")
	get_tree().disconnect("connection_failed", self, "_process_failed_join")
	get_tree().network_peer = null


func _process_successful_join() -> void:
	# Stop listening for failed connection
	get_tree().disconnect("connection_failed", self, "_process_failed_join")

	_connection_dialog.hide()
	emit_signal("joined")

	_set_configurable(false)
	show()


func _process_failed_join() -> void:
	# Stop listening for success connection
	get_tree().disconnect("connected_to_server", self, "_process_successful_join")

	_connection_dialog.hide()
	_error_dialog.show_error("Unable to join lobby")


func _confirm_configuration() -> void:
	var peer: = NetworkedMultiplayerENet.new()
	var result: int = peer.create_server(int(_port_spin.value))
	if result != OK:
		_error_dialog.show_error("Unable to create server")
		return

	_set_configurable(false)
	set_process_unhandled_input(true)

	get_tree().network_peer = peer


func _set_configurable(configurable: bool):
	if configurable == _configurable:
		return
	_configurable = configurable
	_port_spin.editable = _configurable
	_server_name_edit.editable = _configurable

	emit_signal("configurable_changed", _configurable)
