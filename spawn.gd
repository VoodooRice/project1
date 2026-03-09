# spawn.gd：通用对象生成器
extends Node2D
class_name Spawn # 定义为类名

# 导出变量
@export var scene_to_spawn: PackedScene

# 公共接口
func spawn():
	# 安全检查：确保设置了要生成的场景
	if scene_to_spawn == null:
		# push_error 在编辑器和输出面板显示红色错误信息
		push_error("没有设置要生成的场景！")
		return # 提前返回，不继续执行
	
	# 实例化预设场景
	var instance = scene_to_spawn.instantiate()
	# 设置实例位置为生成器自身的位置
	instance.position = position
	# 将实例添加到当前场景中
	get_tree().current_scene.add_child(instance)
	# 调试输出，确认生成成功
	print("角色生成成功！位置：", position)
	# 返回生成的实例，以便调用方进行后续操作
	return instance
