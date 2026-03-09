### 未完成
# game_scene.gd 游戏场景基类
#
# 设计目标：作为所有游戏场景的基类，提供统一的玩家生成、重生和场景切换功能
# 配合 SceneTransition 等实现场景间的平滑过渡和位置记忆
#
# 当前状态：基础框架已完成，但未被实际场景继承使用
extends Node
class_name GameScene # 定义为类名，便于其他脚本引用和类型检查

# 节点引用
# 期望每个继承此脚本的场景都包含一个名为"Spawn"的子节点
# 作为默认的玩家生成点（当没有场景切换数据时使用）
@onready var spawn_node = $Spawn # 注意：此处未指定具体节点

@export var player_scene: PackedScene

# 生命周期函数
func _ready() -> void:
	# 调试输出：显示当前场景的名称
	print("场景加载： ", name)

# 玩家生成系统
# 想要在此实现智能生成玩家的功能：优先使用场景切换的位置，否则使用默认位置
# 这是一个私有函数，只在内部逻辑调用
func _spawn_player():
	if has_node("/root/SceneTransition"):
		# 检查场景切换系统是否存在
		var transition = get_node("/root/SceneTransition")
		
		# 从切换系统中获取应该生成的位置
		# 返回合适的生成点坐标
		var spawn_position = transition.get_spawn_transition(name)
		
		var player = player_scene.instantiate()
		player.position = spawn_position
		add_child(player) # 将玩家添加到当前场景
		
		# 连接死亡信号
		if player.has_signal("died"):
			player.died.connect(_on_player_died)
		
		print("玩家生成在位置： ", spawn_position)
		
	else:
		_spawn_at_default()
	

func _spawn_at_default():
	if spawn_node:
		# 使用导出的玩家场景资源实例化新玩家
		var player = player_scene.instantiate()
		# 将玩家设置在 Spawn 节点的位置
		player.position = spawn_node.position
		add_child(player)
		
		# 连接死亡信号
		if player.has_signal("died"):
			player.died.connect(_on_player_died)
	else:
		# 严重错误：场景中没有配置 Spawn 节点
		# push_error 会在编辑器和输出面板显示红色错误信息
		push_error("GameScene: 找不到Spawn节点，无法生成玩家")

# 死亡重生系统
func _on_player_died():
	await get_tree().create_timer(0.5).timeout
	_respawn_player()
	
func _respawn_player():
	call_deferred("_spawn_player")
