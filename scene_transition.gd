extends Node
class_name SceneTransition

var spawn_config = {
	"forest":{
		"default": Vector2(100,560),
		"forest_right":Vector2(750,560)
	},
	"forest2":{
		"default":Vector2(50,560)
	}
}

var last_transition = {
	"from": "",
	"to": "",
	"direction": ""
}

var scene_connections = {
	"forest": ["forest2"],
	"forest2": ["forest"]
}

func can_transition(from_scene: String, to_scene: String) -> bool:
	var connections = scene_connections.get(from_scene, [])
	return to_scene in connections

func get_spawn_transition(current_scene: String) -> Vector2:
	var config = spawn_config.get(current_scene, {})
	
	if last_transition.to == current_scene and last_transition.from:
		var key = last_transition.from + "_" + last_transition.direction
		if config.has(key):
			return config[key]
	
	return config.get("default")

func record_transition(from_scene: String, to_scene: String, direction: String):
	last_transition = {
		"from": from_scene,
		"to": to_scene,
		"direction": direction
	}
	print("场景切换：", from_scene, " -> ", to_scene, "(方向：", direction, ")")
	
func clear_transition():
	last_transition = {
		"from": "",
		"to": "",
		"direction": ""
	}
