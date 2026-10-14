## Hit points for any entity (heroine, enemies, boss). Pure logic, no visuals.
## Talks to: the owner listens to `health_changed` and `died`.
class_name HealthComponent
extends Node

## Emitted after any change in hit points.
signal health_changed(current: int, maximum: int)
## Emitted once when hit points reach zero. Fires again only after reset().
signal died

## Maximum hit points.
@export var max_health: int = 10

## Current hit points.
var current_health: int = 0

var _dead: bool = false


func _ready() -> void:
	current_health = max_health


## Sets a new maximum and refills hit points. Use when reusing pooled entities.
func setup(new_max_health: int) -> void:
	max_health = new_max_health
	reset()


## Refills hit points and clears the dead state.
func reset() -> void:
	current_health = max_health
	_dead = false
	health_changed.emit(current_health, max_health)


## Applies damage. Ignored when already dead or `amount` is not positive.
func take_damage(amount: int) -> void:
	if _dead or amount <= 0:
		return
	current_health = maxi(current_health - amount, 0)
	health_changed.emit(current_health, max_health)
	if current_health == 0:
		_dead = true
		died.emit()


## Restores hit points up to the maximum.
func heal(amount: int) -> void:
	if _dead or amount <= 0:
		return
	current_health = mini(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)
