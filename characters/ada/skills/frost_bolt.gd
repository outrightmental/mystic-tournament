class_name FrostBolt
extends BaseSkill


func use(caster: BaseHero, transform: Transform) -> void:
	var frost_bold: KinematicBody = preload("res://characters/ada/skills/frost_bolt_projectile.tscn").instance()
	frost_bold.global_transform = transform
	frost_bold.caster = caster
	Gamemode.map.add_child(frost_bold)
