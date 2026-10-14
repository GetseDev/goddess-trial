## Area that receives contact damage from overlapping areas.
## Damages `health` by the overlapping area's get_contact_damage(), then waits
## `invulnerability_time` seconds before it can be hurt again.
## Talks to: HealthComponent (assigned in the editor). Knows nothing about Enemy.
class_name Hurtbox
extends Area2D

## Health that receives the damage.
@export var health: HealthComponent
## Seconds of immunity after taking a hit.
@export var invulnerability_time: float = 0.6

var _cooldown: float = 0.0


func _physics_process(delta: float) -> void:
	_cooldown = maxf(_cooldown - delta, 0.0)
	if _cooldown > 0.0 or health == null:
		return
	for area: Area2D in get_overlapping_areas():
		if area.has_method("get_contact_damage"):
			health.take_damage(area.call("get_contact_damage"))
			_cooldown = invulnerability_time
			return
