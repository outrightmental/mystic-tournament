class_name ValueBar
extends TextureProgress


onready var _value_label: Label = $ValueLabel


func _set_value_label(new_value: int) -> void:
	_value_label.text = "%d/%d" % [new_value, max_value]
