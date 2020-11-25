class_name Ada
extends BaseHero


onready var _frost_bolt_spawn: Position3D = $Mesh/FrostBoltSpawn


func _ready() -> void:
	_abilities[BASE_ATTACK] = FrostBolt.new()
	_abilities_spawn_positions[BASE_ATTACK] = _frost_bolt_spawn
