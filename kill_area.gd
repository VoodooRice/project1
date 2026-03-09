# kill_area.gd：创建一个区域，当玩家进入该区域内对其造成伤害
# 需要挂载在 Area2d 节点上使用，通过 CollisionShape2D 定义危险区域的形状和大小
extends Area2D

# 信号回调函数
func _on_body_entered(body: Node2D) -> void:
	# 判断进入的物体是否为玩家，使用is进行关键字判断
	# 防止未来的其他物体进入时也收到伤害
	if not body is Player:
		return # 如果不是玩家，直接退出函数
	
	# 类型转换，调用 player.gd 中的hurt函数，触发玩家的受伤逻辑
	(body as Player).hurt() 
