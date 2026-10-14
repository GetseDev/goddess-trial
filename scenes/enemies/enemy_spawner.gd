## Spawns pooled enemies in a ring around the target at a fixed interval.
## Returns enemies to the pool when they are defeated.
## Talks to: Main sets `target`; listens to Enemy.defeated.
class_name EnemySpawner
extends Node

## Enemy type to spawn.
@export var enemy_data: EnemyData
## Seconds between spawns.
@export var spawn_interval: float = 1.0
## Maximum enemies alive at once.
@export var max_enemies: int = 100
## Distance in pixels from the target where enemies appear. Keep it larger than
## half the screen diagonal so they spawn off-screen.
@export var spawn_radius: float = 600.0

## Node the enemies chase (the heroine). Set by Main.
var target: Node2D

var _active_count: int = 0

@onready var _pool: ObjectPool = $EnemyPool
@onready var _timer: Timer = $SpawnTimer


func _ready() -> void:
	_timer.wait_time = spawn_interval
	_timer.timeout.connect(_spawn)


## Returns an enemy to the pool.
func despawn(enemy: Enemy) -> void:
	_pool.release(enemy)
	_active_count -= 1


func _spawn() -> void:
	if target == null or _active_count >= max_enemies:
		return
	var enemy: Enemy = _pool.acquire() as Enemy
	if not enemy.defeated.is_connected(despawn):
		enemy.defeated.connect(despawn)
	enemy.setup(enemy_data, target)
	enemy.global_position = target.global_position + Vector2.from_angle(randf() * TAU) * spawn_radius
	_active_count += 1
