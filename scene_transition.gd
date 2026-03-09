# scene_transition.gd：场景切换管理器
extends Node
class_name SceneTransition# 定义为类名

# 场景生成配置
# 各场景的生成配置点字典
var spawn_config = {
	"forest":{
		"default": Vector2(90,530),# 默认生成在 (90,530)
		"forest2_left":Vector2(650,530) # 从 forest 右侧进入时的重生点
	},
	"forest2":{
		"default":Vector2(50,560) # 默认生成在 (50,560)
	}
}

# 最近切换记录
# 记录上一次场景切换的信息
var last_transition = {
	"from": "", # 来源场景名称
	"to": "", # 目标场景名称
	"direction": "" # 离开方向（left/right/up/down）
}

# 场景连接关系
# 定义哪些场景之间可以互相切换
# 用于验证切换是否合法，防止直接切换到不相关的场景
var scene_connections = {
	"forest": ["forest2"],
	"forest2": ["forest"]
}

# 获取当前场景应该生成玩家的位置
func get_spawn_transition(current_scene: String) -> Vector2:
	# 获取当前场景的配置，如果没有则返回空字典
	var config = spawn_config.get(current_scene, {})
	# 检查是否有有效的切换记录
	if last_transition.to == current_scene and last_transition.from:
		# 构建键名：来源场景_方向
		var key = last_transition.from + "_" + last_transition.direction

		# 如果配置中有这个键名，返回对应的位置
		if config.has(key):
			return config[key]
	
	# 没有匹配的切换记录，返回默认生成位置
	return config.get("default")

# 记录场景切换信息
func record_transition(from_scene: String, to_scene: String, direction: String):
	last_transition = {
		"from": from_scene,
		"to": to_scene,
		"direction": direction
	}
	print("场景切换：", from_scene, " -> ", to_scene, "(方向：", direction, ")")

# 清除切换记录
func clear_transition():
	last_transition = {
		"from": "",
		"to": "",
		"direction": ""
	}
