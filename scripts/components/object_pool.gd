## Generic pool of Node2D instances of one scene. Avoids instantiate()/queue_free()
## in hot loops (enemies, projectiles, XP gems).
## Pooled nodes may implement on_acquired() / on_released() to reset their state.
## Talks to: whoever owns it (e.g. EnemySpawner) calls acquire() and release().
class_name ObjectPool
extends Node2D

## Scene instantiated by the pool. Its root must be a Node2D.
@export var scene: PackedScene
## Number of instances created up front in _ready().
@export var prewarm: int = 0

var _free: Array[Node2D] = []


func _ready() -> void:
	for _i: int in prewarm:
		_free.append(_create())


## Returns an active instance, creating one only if the pool is empty.
func acquire() -> Node2D:
	var node: Node2D = _free.pop_back() if not _free.is_empty() else _create()
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node.show()
	if node.has_method("on_acquired"):
		node.call("on_acquired")
	return node


## Deactivates the instance and makes it available again.
func release(node: Node2D) -> void:
	_deactivate(node)
	_free.append(node)


func _create() -> Node2D:
	var node: Node2D = scene.instantiate() as Node2D
	add_child(node)
	_deactivate(node)
	return node


func _deactivate(node: Node2D) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.hide()
	if node.has_method("on_released"):
		node.call("on_released")
