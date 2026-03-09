# player.gd：角色状态机
extends CharacterBody2D
class_name Player# 定义为类名，便于其他脚本引用和类型检查

# 信号定义
signal died

# 状态枚举
enum State{ 
	STAND,
	RUN,
	JUMP,
	CLIMB,
	HURT
}

# 全局常量设定
# 从项目中获取默认重力值
var g = ProjectSettings.get_setting("physics/2d/default_gravity")

# 状态变量
# 当前玩家状态默认为站立
var state : State = State.STAND

# 导出变量
# 水平移动速度（像素/秒）
@export var speed : int = 250
# 跳跃初速度（像素/秒，负值表示向上）
@export var jump_speed : int = 350

# 节点引用
# 动画 pixel 节点，用于播放不同的动画
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
# 受伤闪白效果节点
@onready var hit_flash : Node = $HitFlash

# 生命周期函数
func _process(delta: float) -> void:
	play_animation() # 根据当前状态播放对应动画

func _physics_process(delta: float) -> void:
	# 受伤状态时，不处理移动输入
	if state == State.HURT:
		return
	# 应用重力
	velocity.y += g * delta
	# 处理移动输入
	moving_input()
	# 应用移动并处理碰撞
	move_and_slide()
	
	# 在地面上时的状态转换
	if is_on_floor():
		# 如果刚从跳跃状态落地，或者没有水平速度，转为站立
		if state == State.JUMP or velocity.x == 0:
			state = State.STAND
		# 其他情况（有水平速度且不处于受伤状态），转为奔跑
		elif state != State.HURT or velocity.x != 0:
			state = State.RUN
	# 在空中时的状态由 play_animation 中的逻辑处理

# 伤害系统
# 玩家受伤时调用
func hurt():
	# 切换到受伤状态，停止输入响应
	state = State.HURT
	# 创建缓动动画序列
	var tween = create_tween()
	tween.set_loops(1) # 只执行一次
	
	# 动画序列：
	# 1. 立即触发闪白效果
	tween.tween_callback(hit_flash.flash)
	# 2. 等待1秒（受伤硬直时间）
	tween.tween_interval(1)
	# 等待1秒后执行死亡
	await get_tree().create_timer(1).timeout
	# 从场景中移除玩家
	queue_free()
	# 发出死亡信号
	died.emit()

# 输入处理
func moving_input():
	# 在地面上时，水平速度初始化为0
	# 这样如果不按方向键，角色会停止
	if is_on_floor():
		velocity.x = 0
	
	# 如果没有按下任何按键，且在地面上，且不处于受伤状态
	# 设置为站立状态并停止移动
	if not Input.is_anything_pressed() and is_on_floor() and state != State.HURT:
		state = State.STAND
		velocity.x = 0
		return
	# 向左移动
	if Input.is_action_pressed("move_left"):
		if is_on_floor():
			state = State.RUN # 在地面移动时设为奔跑状态
		velocity.x = -speed
		sprite.flip_h = true # 水平翻转 pixel
	# 向右移动
	if Input.is_action_pressed("move_right"):
		if is_on_floor():
			state = State.RUN
		velocity.x = speed
		sprite.flip_h = false # 恢复正常方向
	if Input.is_action_just_pressed("jump"):
		# 防止二段跳：如果不在空中，或者已经在跳跃/下落，不能再次跳跃
		if not is_on_floor() and (state == State.JUMP or velocity.y < 0):
			return
		# 设置为跳跃状态
		state = State.JUMP
		# 应用跳跃初速度（负值向上）
		velocity.y = -jump_speed
		return

# 动画系统
# 根据当前状态和物理条件播放对应动画
func play_animation():
	# 空中状态优先处理（覆盖地面状态）
	if not is_on_floor() and state != State.HURT:
		if velocity.y < 0:
			# 向上运动时播放跳跃动画
			sprite.play("jump")
		else:
			# 向下运动时播放下落动画
			sprite.play("fall")
	# 根据状态枚举播放对应动画
	match state:
		State.STAND:
			sprite.play("stand")
		State.RUN:
			sprite.play("run")
		State.HURT:
			sprite.play("hurt")
