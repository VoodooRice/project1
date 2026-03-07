extends Node2D
class_name Spawn

@export var scene_to_spawn: PackedScene

func spawn():
	if scene_to_spawn == null:
		push_error("没有设置要生成的场景！")
		return
	var instance = scene_to_spawn.instantiate()
	instance.position = position
	get_tree().current_scene.add_child(instance)
	print("角色生成成功！位置：", position)
	return instance
