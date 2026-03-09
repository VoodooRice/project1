# hit_flash：当玩家受伤时，通过调整着色器参数动画实现短暂的闪白效果
# 附着在 Player 节点上，控制其节点 AnimatedSprite2D
extends Node

# 节点引用
# 获取被控制角色的 pixel 节点
@onready var animated_sprite_2d : AnimatedSprite2D = $"../AnimatedSprite2D"

# 运行时变量

# 存储从精灵节点获取的着色器材质引用
# 使用ShaderMaterial类型以便调用着色器相关方法
var sprite_material : ShaderMaterial

# 缓动动画对象，用于控制闪白效果的平滑过渡
# 保存引用以便在需要时中断正在进行的动画
var hit_flash_tween : Tween

# 生命周期函数
func _ready() -> void:
	# 从精灵节点获取材质
	sprite_material = animated_sprite_2d.material

# 公共接口
# 触发闪白效果
# 工作流程：
# 1.如果有正在进行的闪白动画，先停止它
# 2.将着色器参数"percent"设置为1.0（完全白色）
# 3.创建新的缓动动画，在0.5秒内将percent从1.0渐变回0.0
#
# 效果：pixel瞬间变白然后逐渐恢复
func flash() -> void:
	# 检查并清理已有的动画
	# 防止多个闪白效果叠加，确保每次受伤都从完整的白色开始
	if hit_flash_tween != null and hit_flash_tween.is_valid():
		hit_flash_tween.kill() # 立即停止当前动画
	
	# 立即将材质参数设置为1.0（瞬间变白）
	sprite_material.set_shader_parameter("percent", 1.0)
	
	# 创建新的缓动动画
	hit_flash_tween = create_tween()
	
	# 设置动画：将"percent"参数从当前值(1.0)渐变到0.0，用时0.5秒
	hit_flash_tween.tween_property(sprite_material, "shader_parameter/percent", 0.0, 0.5)
