## Heroine controller. Reads movement input and moves the body.
## Talks to: nothing yet (the virtual joystick will feed the same input actions).
class_name Player
extends CharacterBody2D

## Movement speed in pixels per second.
@export var speed: float = 300.0


func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()
