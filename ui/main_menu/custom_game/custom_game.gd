extends HBoxContainer


onready var _servers: PanelContainer = $Servers
onready var _lobby: PanelContainer = $Lobby


func back() -> void:
	if _lobby.visible:
		_lobby.leave()
	else:
		hide()


func _switch_panels() -> void:
	_servers.visible = !_servers.visible
	_lobby.visible = !_lobby.visible
