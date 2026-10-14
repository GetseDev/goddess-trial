## In-run heads-up display. Presentation only: Main pushes values into it.
## Talks to: nothing; Main connects Player.health_changed to set_health().
class_name Hud
extends Control

@onready var _health_label: Label = $HealthLabel


## Shows the heroine's hit points.
func set_health(current: int, maximum: int) -> void:
	_health_label.text = "HP %d / %d" % [current, maximum]
