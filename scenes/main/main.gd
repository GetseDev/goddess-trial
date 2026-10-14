## Root scene of the game. Wires UI input, enemy spawning and the HUD to the
## player and draws a placeholder grid so movement is visible.
## Talks to: TouchJoystick -> Player.set_touch_direction(); Player.health_changed
## -> Hud.set_health(); gives the Player to EnemySpawner as its chase target.
## Placeholder: when the heroine dies the scene simply restarts.
extends Node2D

## Distance in pixels between grid lines.
const GRID_STEP: int = 100
## Half-size in pixels of the drawn placeholder grid.
const GRID_HALF_SIZE: int = 3000

@onready var _player: Player = $Player
@onready var _joystick: TouchJoystick = $UI/TouchJoystick
@onready var _hud: Hud = $UI/Hud
@onready var _spawner: EnemySpawner = $EnemySpawner


func _ready() -> void:
	_joystick.direction_changed.connect(_player.set_touch_direction)
	_player.health_changed.connect(_hud.set_health)
	_player.died.connect(_on_player_died)
	_spawner.target = _player
	_player.announce_health()


func _draw() -> void:
	var color: Color = Color(1.0, 1.0, 1.0, 0.08)
	for i: int in range(-GRID_HALF_SIZE, GRID_HALF_SIZE + 1, GRID_STEP):
		draw_line(Vector2(i, -GRID_HALF_SIZE), Vector2(i, GRID_HALF_SIZE), color)
		draw_line(Vector2(-GRID_HALF_SIZE, i), Vector2(GRID_HALF_SIZE, i), color)


func _on_player_died() -> void:
	get_tree().reload_current_scene.call_deferred()
