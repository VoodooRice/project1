extends Node2D

@onready var tilemap_1: TileMapLayer = $TileMap1
@onready var tilemap_2: TileMapLayer = $TileMap2
@onready var player_spawner: Spawn = $PlayerSpawner

@export var tilemaps: Array[TileMapLayer]

@export var tilemap_width: float = 800.0
var current_tilemap_index: int = -1

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_tilemap_active(tilemap: TileMapLayer, active: bool):
	tilemap.visible = active
	if active:
		tilemap.process_mode = Node.PROCESS_MODE_INHERIT
		tilemap.set_collision_enabled(true)
	else:
		tilemap.process_mode = Node.PROCESS_MODE_DISABLED
		tilemap.set_collision_enabled(false)
