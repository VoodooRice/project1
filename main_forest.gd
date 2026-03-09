### 未完成

# main_forest 大型地图管理器
#
# 设计目标：创造一个由多个 Tilemap 区块组成的大型连续地图
# 根据玩家的不同位置进行动态激活/禁用不同的地图区块
#
# 核心逻辑待实现
extends Node2D

# 节点引用
# 通过 @onready 延迟获取子节点的引用，确保当前节点就绪后可用
@onready var tilemap_1: TileMapLayer = $TileMap1 # 第一个地图区块
@onready var tilemap_2: TileMapLayer = $TileMap2 # 第二个地图区块
@onready var player_spawner: Spawn = $PlayerSpawner # 玩家生成点

# 导出变量
# 通过 @export 实现如下变量在检查器面板中的配置
@export var tilemaps: Array[TileMapLayer] # 所有地图区块的数组，方便统一管理
@export var tilemap_width: float = 800.0 # 每个地图区块的宽度（像素）

# 运行时变量
var current_tilemap_index: int = -1 # 当前激活的地图区块索引，-1表示未激活

# 生命周期函数
func _ready() -> void:
	# TODO：在这里实现初始化逻辑
	# 待办：
	# 1.生成玩家
	# 2.初始化第一个地图区块
	# 3.连接玩家的位置变化信号（如果有）
	pass

func _process(delta: float) -> void:
	# TODO：实现大场景地图切换的核心逻辑
	# 待办：
	# 1.获取玩家当前的坐标
	# 2.根据当前坐标计算应该激活什么区块
	# 3.如果需要切换，则调用scene_transition
	pass

# 自定义功能函数
# tilemap：要设置的地图区块节点
# active：true = 激活（可见、有物理碰撞、可处理逻辑）
#         false = 激活（不可见、无物理碰撞、不处理逻辑）
func set_tilemap_active(tilemap: TileMapLayer, active: bool):
	tilemap.visible = active
	if active:
		# 激活状态：继承父节点的处理模式，启用碰撞
		tilemap.process_mode = Node.PROCESS_MODE_INHERIT
		tilemap.set_collision_enabled(true)
	else:
		# 禁用状态：完全禁用处理，关闭碰撞
		tilemap.process_mode = Node.PROCESS_MODE_DISABLED
		tilemap.set_collision_enabled(false)
