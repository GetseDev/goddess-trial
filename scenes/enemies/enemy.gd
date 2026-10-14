## Basic chasing enemy. Walks straight toward its target; stats come from EnemyData.
## Talks to: EnemySpawner calls setup(); ObjectPool calls on_acquired()/on_released().
## Combat (health, contact damage) is not implemented yet.
class_name Enemy
extends Area2D

## Stats and look of this enemy. Set by setup().
var data: EnemyData

var _target: Node2D

@onready var _body: Polygon2D = $Body


## Configures the enemy for a new life. Call right after ObjectPool.acquire().
func setup(enemy_data: EnemyData, target: Node2D) -> void:
	data = enemy_data
	_target = target
	_body.color = data.color


func _physics_process(delta: float) -> void:
	if _target == null:
		return
	var to_target: Vector2 = _target.global_position - global_position
	if to_target.length_squared() > 1.0:
		global_position += to_target.normalized() * data.speed * delta


## Pool hook: becomes detectable by other areas again.
func on_acquired() -> void:
	set_deferred("monitorable", true)


## Pool hook: stop being detected while idle in the pool.
func on_released() -> void:
	_target = null
	set_deferred("monitorable", false)
