extends Area2D
class_name MapSwitch

@export var target_scene_path: String = ""
@export var exit_direction:String = "right"

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	if has_node("/root/SceneTransition"):
		var transition = get_node("/root/SceneTransition")
		var current_scene = get_tree().current_scene.name
		transition.record_transition(current_scene, get_scene_name_from_path(target_scene_path), exit_direction)
	print("player进入场景")
	
	call_deferred("switch")

func switch_scene():
	if target_scene_path.is_empty():
		push_error("未设置目标场景路径")
		return
	
	var scene = load(target_scene_path)
	if scene:
		get_tree().change_scene_to_packed(scene)
	else:
		push_error("无法加载场景 " + target_scene_path)

func get_scene_name_from_path(path: String) -> String:
	var file_name = path.get_file()
	return file_name.replace(".tscn", "")
