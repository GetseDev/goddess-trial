## Heroine controller. Reads movement input and moves the body.
## Talks to: receives the virtual joystick direction via set_touch_direction();
## re-emits its HealthComponent signals so Main/HUD don't reach into children.
## Keyboard (arrow keys) is kept as a fallback for desktop testing.
class_name Player
extends CharacterBody2D

## Emitted when hit points change (for the HUD).
signal health_changed(current: int, maximum: int)
## Emitted when hit points reach zero.
signal died

## Movement speed in pixels per second.
@export var speed: float = 300.0

var _touch_direction: Vector2 = Vector2.ZERO

@onready var _health: HealthComponent = $Health


func _ready() -> void:
	_health.health_changed.connect(health_changed.emit)
	_health.died.connect(died.emit)


func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction == Vector2.ZERO:
		direction = _touch_direction
	velocity = direction * speed
	move_and_slide()


## Emits the current hit points so late listeners (HUD) can sync at startup.
func announce_health() -> void:
	health_changed.emit(_health.current_health, _health.max_health)


## Sets the joystick direction (length 0..1). Zero vector stops the heroine.
func set_touch_direction(direction: Vector2) -> void:
	_touch_direction = direction
