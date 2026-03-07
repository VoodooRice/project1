extends Node2D
@onready var player_spawner : Spawn = $spawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("forest场景已加载")
	print("player_spawner: ", player_spawner)
	if player_spawner:
		print("要生成的场景: ", player_spawner.scene_to_spawn)
		var player = player_spawner.spawn() as Player
		player.died.connect(_on_player_died)
		call.call_deferred("add_child", player)
	else:
		print("错误：没有找到spawn节点")

func _on_player_died():
	await get_tree().create_timer(0.5).timeout
	var new_player = player_spawner.spawn()
	new_player.died.connect(_on_player_died)
