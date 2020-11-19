class_name Ada
extends BaseHero


onready var _frost_bolt_spawn: Position3D = $Mesh/FrostBoltSpawn


func _ready() -> void:
	_skils[BASE_ATTACK] = FrostBolt.new()
	_skils_spawn_positions[BASE_ATTACK] = _frost_bolt_spawn
