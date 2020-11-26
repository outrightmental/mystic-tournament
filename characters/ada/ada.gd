class_name Ada
extends BaseHero


onready var _frost_bolt_spawn: Position3D = $Mesh/FrostBoltSpawn


func _ready() -> void:
	set_ability(BASE_ATTACK, FrostBolt.new(), _frost_bolt_spawn)
