## Root scene of the game. Wires UI input and enemy spawning to the player and
## draws a placeholder grid so movement is visible. Contains no combat logic.
## Talks to: TouchJoystick (signal) -> Player.set_touch_direction();
## gives the Player to EnemySpawner as its chase target.
extends Node2D

## Distance in pixels between grid lines.
const GRID_STEP: int = 100
## Half-size in pixels of the drawn placeholder grid.
const GRID_HALF_SIZE: int = 3000

@onready var _player: Player = $Player
@onready var _joystick: TouchJoystick = $UI/TouchJoystick
@onready var _spawner: EnemySpawner = $EnemySpawner


func _ready() -> void:
	_joystick.direction_changed.connect(_player.set_touch_direction)
	_spawner.target = _player


func _draw() -> void:
	var color: Color = Color(1.0, 1.0, 1.0, 0.08)
	for i: int in range(-GRID_HALF_SIZE, GRID_HALF_SIZE + 1, GRID_STEP):
		draw_line(Vector2(i, -GRID_HALF_SIZE), Vector2(i, GRID_HALF_SIZE), color)
		draw_line(Vector2(-GRID_HALF_SIZE, i), Vector2(GRID_HALF_SIZE, i), color)
