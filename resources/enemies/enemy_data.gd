## Balance and look data for one enemy type. Edit the .tres files, not code.
## Used by: Enemy reads it in setup(); EnemySpawner decides which one to spawn.
class_name EnemyData
extends Resource

## Name shown in debug tools and, later, in the bestiary.
@export var display_name: String = "Grunt"
## Hit points at spawn.
@export var max_health: int = 10
## Chase speed in pixels per second.
@export var speed: float = 80.0
## Damage dealt to the heroine on contact.
@export var contact_damage: int = 5
## Placeholder body color until final art exists.
@export var color: Color = Color(0.85, 0.25, 0.25)
