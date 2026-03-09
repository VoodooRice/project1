extends Node2D
# 森林主场景
# 负责管理玩家重生及场景初始化

# 在 _ready 前，确保所有子节点全部就绪后，调用 spawn
@onready var player_spawner : Spawn = $spawn

# 场景就绪后自动调用
func _ready() -> void:
	# 调试输出，方便确认场景是否成功加载
	print("===== forest_2场景已加载 =====")
	print("player_spawner: ", player_spawner) # 检查是否存在 spawn 节点
	
	# 安全检查：确保 spawn 节点存在
	if player_spawner:
		print("要生成的场景: ", player_spawner.scene_to_spawn) # 确认要生成的对象
		
		# 使用 spawn 节点生成玩家，并通过 as Player 返回为 Player 类型并调用
		var player = player_spawner.spawn() as Player
		
		# 检查是否有 SceneTransitionManager 并获取正确的位置
		if has_node("/root/SceneTransitionManager"):
			var transition = get_node("/root/SceneTransitionManager")
			var spawn_position = transition.get_spawn_transition(name)
			player.position = spawn_position
			print("使用 SceneTransition 位置: ", spawn_position)
		
		# 连接玩家的死亡信号
		player.died.connect(_on_player_died)
		
		# 延迟添加节点，避免在场景初始化的过程中出现问题
		call.call_deferred("add_child", player)
	else:
		# 如果场景中没有配置 spawn 节点，则输出错误信息
		print("错误：没有找到spawn节点")

# 在玩家死亡后自动调用
func _on_player_died():
	
	# 在玩家死亡后，通过 await get_tree().create_timer(0.5).timeout 实现等待五秒的效果
	# 用来提醒玩家已经角色死亡
	await get_tree().create_timer(0.5).timeout
	
	# 使用同一个 spawn 节点生成新玩家
	var new_player = player_spawner.spawn()
	
	# 为新玩家连接死亡信号，形成循环
	new_player.died.connect(_on_player_died)
