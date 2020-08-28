extends PanelContainer
# Represents the lobby and manages connections to it


signal joined
signal configuring_started
signal created

onready var _error_dialog: ErrorDialog = $ErrorDialog
onready var _connection_dialog: ConnectionDialog = $ConnectionDialog
onready var _server_name_edit: LineEdit = $VBox/Grid/ServerNameEdit
onready var _addresses_edit: LineEdit = $VBox/Grid/AddressesEdit
onready var _port_spin: SpinBox = $VBox/Grid/PortSpin


func configure():
	show()
	# TODO: Display all addresses here
	_addresses_edit.text = IP.get_local_addresses().front()
	emit_signal("configuring_started")


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


func _confirm_creation() -> void:
	var peer: = NetworkedMultiplayerENet.new()
	var result: int = peer.create_server(int(_port_spin.value))
	if result != OK:
		_error_dialog.show_error("Unable to create server")
		return
	
	_port_spin.editable = false
	_server_name_edit.editable = false
		
	get_tree().network_peer = peer
	emit_signal("created")


func _cancel_join() -> void:
	get_tree().disconnect("connected_to_server", self, "_process_successful_join")
	get_tree().disconnect("connection_failed", self, "_process_failed_join")
	get_tree().network_peer = null


func _process_successful_join() -> void:
	# Stop listening for failed connection
	get_tree().disconnect("connection_failed", self, "_process_failed_join")

	_connection_dialog.hide()
	emit_signal("joined")
	show()


func _process_failed_join() -> void:
	# Stop listening for success connection
	get_tree().disconnect("connected_to_server", self, "_process_successful_join")

	_connection_dialog.hide()
	_error_dialog.show_error("Unable to join lobby")
