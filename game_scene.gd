extends Node
class_name GameScene

@onready var spawn_node = $Spawn

func _ready() -> void:
	print("场景加载： ", name)

func _spawn_player():
	if has_node("/root/SceneTransition"):
		var transition = get_node("/root/SceneTransition")
		var spawn_position = transition.get_spawn_transition(name)
		
		var player_scene = load("res://player.tscn")
		var player = player_scene.instantiate()
		player.position = spawn_position
		add_child(player)
		
		if player.has_signal("died"):
			player.died.connect(_on_player_died)
		
		print("玩家生成在位置： ", spawn_position)
		

func _spawn_at_default():
	if spawn_node:
		var player_scene = load("res://player.tscn")
		var player = player_scene.instantiate()
		player.position = spawn_node.position
		add_child(player)
		
		if player.has_signal("died"):
			player.died.connect(_on_player_died)

func _on_player_died():
	await get_tree().create_timer(0.5).timeout
	_respawn_player()
	
func _respawn_player():
	call_deferred("_spawn_player")
