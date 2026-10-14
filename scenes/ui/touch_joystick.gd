## Floating virtual joystick for one-thumb touch control.
## Appears where the finger touches and reports a direction (length 0..1).
## Talks to: Main connects `direction_changed` to Player.set_touch_direction().
class_name TouchJoystick
extends Control

## Emitted whenever the stick direction changes. Zero vector when released.
signal direction_changed(direction: Vector2)

## Maximum distance in pixels the knob can travel from the touch origin.
@export var radius: float = 80.0
## Visual size of the knob in pixels.
@export var knob_radius: float = 32.0
## Fraction of `radius` (0..1) below which the input is ignored.
@export_range(0.0, 1.0) var dead_zone: float = 0.15

var _touch_index: int = -1
var _origin: Vector2 = Vector2.ZERO
var _knob_offset: Vector2 = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch: InputEventScreenTouch = event
		if touch.pressed and _touch_index == -1:
			_touch_index = touch.index
			_origin = _screen_to_local(touch.position)
			_update_stick(_origin)
		elif not touch.pressed and touch.index == _touch_index:
			_release()
	elif event is InputEventScreenDrag:
		var drag: InputEventScreenDrag = event
		if drag.index == _touch_index:
			_update_stick(_screen_to_local(drag.position))


func _draw() -> void:
	if _touch_index == -1:
		return
	draw_circle(_origin, radius, Color(1.0, 1.0, 1.0, 0.15))
	draw_circle(_origin + _knob_offset, knob_radius, Color(1.0, 1.0, 1.0, 0.4))


## Converts a viewport (screen) position to this control's local space.
func _screen_to_local(screen_position: Vector2) -> Vector2:
	return get_global_transform_with_canvas().affine_inverse() * screen_position


func _update_stick(finger_position: Vector2) -> void:
	_knob_offset = (finger_position - _origin).limit_length(radius)
	var direction: Vector2 = _knob_offset / radius
	if direction.length() < dead_zone:
		direction = Vector2.ZERO
	direction_changed.emit(direction)
	queue_redraw()


func _release() -> void:
	_touch_index = -1
	_knob_offset = Vector2.ZERO
	direction_changed.emit(Vector2.ZERO)
	queue_redraw()
