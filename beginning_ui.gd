extends Control
# 开始界面UI控制器
# 负责处理主菜单的按钮交互和场景切换

# 通过 @export 让这个变量能在检查器中显示
# PackedScene 类型意味着可以将场景的tscn文件直接放入Main Scene变量内
@export var main_scene: PackedScene

# 当按下 Start 按钮时调用
# 使用 get_tree().change_scene_to_packed 直接预加载场景
func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(main_scene)

# 当按下 Exit 按钮时调用
func _on_exit_pressed() -> void:
	get_tree().quit()
	
