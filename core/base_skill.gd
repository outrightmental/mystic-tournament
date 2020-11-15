class_name BaseSkill
extends Reference


var spawn_position: Position3D
var caster: BaseHero


func _init(hero: BaseHero, position: Position3D) -> void:
	caster = hero
	spawn_position = position


func use() -> void:
	pass
