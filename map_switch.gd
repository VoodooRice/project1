# map_switch.gd：场景切换触发器
extends Area2D
class_name MapSwitch# 定义为类名，便于其他脚本引用和类型检查

# 导出变量
# 目标场景路径：要切换到的场景路径
@export var target_scene_path: String = ""

# 退出方向
@export var exit_direction:String = ""

# 信息回调函数
func _on_body_entered(body: Node2D) -> void:
	# 只对玩家生效，忽略其他物体
	if not body is Player:
		return
	
	print("===== MapSwitch 触发 =====")
	print("目标场景路径: ", target_scene_path)
	print("退出方向: ", exit_direction)
	
	# 记录场景切换信息
	if has_node("/root/SceneTransitionManager"):
		var transition = get_node("/root/SceneTransitionManager")
		# 获取当前场景名称
		var current_scene = get_tree().current_scene.name
		var target_name = get_scene_name_from_path(target_scene_path)
		print("当前场景: ", current_scene)
		print("目标场景: ", target_name)
		print("退出方向: ", exit_direction)
		
		# 记录切换信息
		transition.record_transition(current_scene, get_scene_name_from_path(target_scene_path), exit_direction)
		print("记录完成")
		
		# 立即查看记录是否保存
		print("记录后 last_transition: ", transition.last_transition)
		
	print("player进入场景") # 调试信息
	
	call_deferred("switch_scene")

# 场景切换逻辑
func switch_scene():
	# 安全检查：确保设置了目标场景路径
	if target_scene_path.is_empty():
		push_error("未设置目标场景路径")
		return
	
	# 动态加载目标场景
	var scene = load(target_scene_path)
	
	# 检查场景是否加载成功
	if scene:
		# 切换到目标场景
		get_tree().change_scene_to_packed(scene)
	else:
		push_error("无法加载场景 " + target_scene_path)

# 辅助函数：用于提取场景的名称
func get_scene_name_from_path(path: String) -> String:
	# 提取路径中的文件名部分
	var file_name = path.get_file()
	# 移除.tscn后缀，只保留纯名称
	return file_name.replace(".tscn", "")
