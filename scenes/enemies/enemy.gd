## Basic chasing enemy. Walks straight toward its target; stats come from EnemyData.
## Talks to: EnemySpawner calls setup() and listens to `defeated`;
## ObjectPool calls on_acquired()/on_released(); Hurtbox reads get_contact_damage();
## Projectile calls take_damage().
class_name Enemy
extends Area2D

## Emitted when hit points reach zero. The spawner returns the enemy to the pool.
signal defeated(enemy: Enemy)

## Stats and look of this enemy. Set by setup().
var data: EnemyData

var _target: Node2D

@onready var _body: Polygon2D = $Body
@onready var _health: HealthComponent = $Health


func _ready() -> void:
	_health.died.connect(func() -> void: defeated.emit(self))


func _physics_process(delta: float) -> void:
	if _target == null:
		return
	var to_target: Vector2 = _target.global_position - global_position
	if to_target.length_squared() > 1.0:
		global_position += to_target.normalized() * data.speed * delta


## Configures the enemy for a new life. Call right after ObjectPool.acquire().
func setup(enemy_data: EnemyData, target: Node2D) -> void:
	data = enemy_data
	_target = target
	_body.color = data.color
	_health.setup(data.max_health)


## Applies damage from an attack.
func take_damage(amount: int) -> void:
	_health.take_damage(amount)


## Damage this enemy deals to the heroine on contact.
func get_contact_damage() -> int:
	return data.contact_damage


## Pool hook: becomes targetable and detectable again.
func on_acquired() -> void:
	add_to_group("enemies")
	set_deferred("monitorable", true)


## Pool hook: leave the targeting group and stop being detected while idle.
func on_released() -> void:
	_target = null
	remove_from_group("enemies")
	set_deferred("monitorable", false)
