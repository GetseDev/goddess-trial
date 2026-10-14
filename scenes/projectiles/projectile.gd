## Straight-flying projectile fired by the heroine. Pooled: never freed.
## Damages the first area it touches that has take_damage(), then returns to its pool.
## Talks to: AutoAttackComponent calls launch(); ObjectPool calls the hooks.
class_name Projectile
extends Area2D

## Flight speed in pixels per second.
@export var speed: float = 500.0
## Seconds before an unused projectile returns to the pool.
@export var lifetime: float = 1.5

var _damage: int = 0
var _direction: Vector2 = Vector2.RIGHT
var _age: float = 0.0
var _pool: ObjectPool
var _spent: bool = false


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	global_position += _direction * speed * delta
	_age += delta
	if _age >= lifetime:
		_recycle()


## Starts the flight. Call right after ObjectPool.acquire().
func launch(pool: ObjectPool, from: Vector2, direction: Vector2, damage: int) -> void:
	_pool = pool
	global_position = from
	_direction = direction.normalized()
	_damage = damage
	rotation = _direction.angle()


## Pool hook: reset flight state and start detecting hits.
func on_acquired() -> void:
	_age = 0.0
	_spent = false
	set_deferred("monitoring", true)


## Pool hook: stop detecting while idle in the pool.
func on_released() -> void:
	set_deferred("monitoring", false)


func _on_area_entered(area: Area2D) -> void:
	if _spent or not area.has_method("take_damage"):
		return
	area.call("take_damage", _damage)
	_recycle()


func _recycle() -> void:
	if _spent:
		return
	_spent = true
	_pool.release(self)
