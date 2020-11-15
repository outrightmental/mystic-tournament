class_name Ada
extends BaseHero


onready var _frost_bolt_spawn: Position3D = $Mesh/FrostBoltSpawn


func _ready() -> void:
	_skils.push_back(FrostBolt.new(self, _frost_bolt_spawn))
