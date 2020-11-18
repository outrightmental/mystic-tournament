class_name FrostBolt
extends BaseSkill


func _init(hero: BaseHero, position: Position3D).(hero, position) -> void:
	pass


func use() -> void:
	var frost_bold: KinematicBody = preload("res://characters/ada/skills/frost_bolt_projectile.tscn").instance()
	frost_bold.global_transform = spawn_position.global_transform
	frost_bold.caster = caster
	Gamemode.map.add_child(frost_bold)
