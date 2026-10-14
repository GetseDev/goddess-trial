## Fires projectiles automatically at the nearest enemy in range.
## Expects its parent to be the Node2D that shoots, a child ObjectPool named
## ProjectilePool (scene: Projectile) and a Timer named AttackTimer.
## Talks to: enemies via the "enemies" group; Projectile.launch().
class_name AutoAttackComponent
extends Node

## Seconds between shots.
@export var attack_interval: float = 0.5
## Maximum distance in pixels to a target.
@export var attack_range: float = 400.0
## Damage per projectile.
@export var damage: int = 5

@onready var _shooter: Node2D = get_parent() as Node2D
@onready var _pool: ObjectPool = $ProjectilePool
@onready var _timer: Timer = $AttackTimer


func _ready() -> void:
	_timer.wait_time = attack_interval
	_timer.timeout.connect(_attack)


func _attack() -> void:
	var target: Node2D = _find_nearest_enemy()
	if target == null:
		return
	var projectile: Projectile = _pool.acquire() as Projectile
	var direction: Vector2 = target.global_position - _shooter.global_position
	projectile.launch(_pool, _shooter.global_position, direction, damage)


func _find_nearest_enemy() -> Node2D:
	var nearest: Node2D = null
	var best_distance: float = attack_range * attack_range
	for node: Node in get_tree().get_nodes_in_group("enemies"):
		var enemy: Node2D = node as Node2D
		var distance: float = _shooter.global_position.distance_squared_to(enemy.global_position)
		if distance < best_distance:
			best_distance = distance
			nearest = enemy
	return nearest
