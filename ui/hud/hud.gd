class_name HUD
extends Control
# Displays elements overlaid on the screen.
# Every human-controlled player in the game has their own instance of the this class which draws separately of other UI.


var character: BaseHero setget set_character

onready var _abilities: HBoxContainer = $Abilities
onready var _hp_bar: ValueBar = $VBox/HBox/HPBar


func _ready() -> void:
	for index in _abilities.get_child_count():
		_abilities.get_child(index).set_action_index(index)


func set_character(new_character: BaseHero) -> void:
	character = new_character

	# warning-ignore:return_value_discarded
	character.connect("health_changed", _hp_bar, "set_value_smoothly")
	_hp_bar.reset(character.health, character.max_health)
