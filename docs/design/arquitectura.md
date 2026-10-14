# Arquitectura de Goddess's Trial

Mapa del proyecto para humanos y agentes de IA. **Léelo antes de buscar código**: indica dónde vive cada cosa y evita recorrer todo el repo. Mantenlo al día cuando se añada o mueva un módulo.

Estado: ✅ existe · 🕓 planeado (la carpeta se crea cuando haga falta; no se generan carpetas vacías).

## Principios

1. **Datos fuera del código.** Diosas, bendiciones, enemigos y mejoras son `Resource` (`.tres`), no constantes en scripts. Balancear no debe requerir tocar GDScript.
2. **Composición sobre herencia.** Comportamientos reutilizables = nodos componente (`HealthComponent`, `Hitbox`), no jerarquías profundas.
3. **Señales hacia arriba, llamadas hacia abajo.** Un nodo hijo emite una señal; el padre o un autoload escucha. Nada de `get_node("../../X")`.
4. **Autoloads solo para estado global.** Son pocos, con una responsabilidad cada uno y sin lógica de escena.
5. **Rendimiento móvil.** Object pooling para enemigos, proyectiles y gemas; sin trabajo innecesario en `_process`.
6. **Cada script vive junto a su escena**, salvo autoloads y componentes compartidos.

## Mapa de carpetas

| Carpeta | Estado | Qué contiene | Reglas |
|---|---|---|---|
| `scenes/player/` | ✅ | Heroína: `player.tscn` + `player.gd` (movimiento) | Un script por escena, mismo nombre |
| `scenes/main/` | ✅ | `main.tscn` + `main.gd`: escena principal (jugador, UI, cuadrícula placeholder). Los menús vendrán aquí | Solo orquesta, sin lógica de combate |
| `scenes/enemies/` | ✅ | `enemy` (persigue al objetivo, placeholder rombo) y `enemy_spawner` (genera en anillo fuera de pantalla con pool). Pendiente: vida y daño por contacto | Leen sus stats de un `EnemyData` |
| `scenes/rooms/` | 🕓 | Salas de 60–90 s y puertas de recompensa | La sala emite `room_cleared` al terminar |
| `scenes/sanctuary/` | 🕓 | Hub de meta-progresión entre partidas | Lee y escribe mejoras vía `SaveManager` |
| `scenes/ui/` | ✅ | `touch_joystick`: joystick flotante táctil (emite `direction_changed`). Pendiente: HUD, pantalla de bendiciones | Solo presentación; reciben datos por señales. `VirtualJoystick` está reservado por Godot 4.7, por eso la clase es `TouchJoystick` |
| `scripts/autoload/` | 🕓 | Singletons globales | Ver tabla de autoloads |
| `scripts/components/` | ✅ | `object_pool.gd` (`ObjectPool`, pool genérico de `Node2D` con hooks `on_acquired`/`on_released`). Pendiente: `HealthComponent`, `Hitbox` | Sin dependencias de escenas concretas |
| `resources/goddesses/` | 🕓 | `GoddessData` (`.tres`) | Datos puros |
| `resources/blessings/` | 🕓 | `BlessingData` (`.tres`) y definición de combos | Datos puros |
| `resources/enemies/` | ✅ | `enemy_data.gd` (`EnemyData`) y `grunt.tres` | Datos puros |
| `assets/art/` | 🕓 | Arte final aprobado, copiado desde `goddess-trial-art-source` | Solo imágenes finales; el material en bruto vive en el otro repo |
| `assets/audio/`, `assets/fonts/` | 🕓 | Sonido y tipografías | — |
| `tests/` | 🕓 | Pruebas de lógica pura (balance, combos, guardado) | — |
| `docs/design/` | ✅ | Diseño, balance y este mapa | En español |
| `docs/adr/` | 🕓 | Decisiones: `NNNN-titulo.md` | En español; contexto, decisión, alternativas, consecuencias |
| `addons/godot_mcp_toolkit/` | ✅ | Plugin del MCP de Godot | **No modificar** |

## Autoloads previstos 🕓

| Autoload | Responsabilidad | Emite |
|---|---|---|
| `GameState` | Estado de la partida en curso: vida, fe, monedas, bendiciones activas | `faith_changed`, `blessing_acquired` |
| `RunManager` | Flujo de la partida: salas, puertas, jefe final, fin de run | `room_started`, `room_cleared`, `run_ended` |
| `SaveManager` | Guardado y carga de la meta-progresión | `save_loaded` |
| `AdsManager` | Anuncios recompensados (mock en escritorio) | `reward_granted` |
| `StoreManager` | Compras in-app (mock en escritorio) | `purchase_completed` |

`AdsManager` y `StoreManager` entran al final del MVP, no antes.

## Componentes previstos 🕓

| Componente | Qué hace |
|---|---|
| `HealthComponent` | Vida, daño y curación; emite `health_changed` y `died` |
| `Hitbox` / `Hurtbox` | Detección de daño por `Area2D` con capas de colisión dedicadas |
| `AutoAttackComponent` | Elige objetivo y dispara las armas de la heroína automáticamente |
| `Pool` | Reutiliza instancias (enemigos, proyectiles, gemas de XP) |

## Flujo de datos (alto nivel)

```
Joystick (UI) ──input──▶ Player ──ataca──▶ Enemy ──muere──▶ Gema XP
                                                      │
Room ──room_cleared──▶ RunManager ──▶ Puertas ──elige──▶ Bendición (BlessingData)
                                                      │
                                       GameState ◀────┘  (fe, bendiciones)
Muerte ──run_ended──▶ SaveManager ──▶ Santuario (mejoras permanentes)
```

## Capas de colisión (propuesta) 🕓

| Capa | Nombre | Uso |
|---|---|---|
| 1 | `player` | Cuerpo de la heroína |
| 2 | `enemy` | Cuerpos de enemigos |
| 3 | `player_attack` | Proyectiles y áreas de ataque de la heroína |
| 4 | `enemy_attack` | Ataques de enemigos |
| 5 | `pickup` | Gemas y monedas |
| 6 | `world` | Paredes y límites de sala |

Al implementarlas, nómbralas en Project Settings → Layer Names para que el código use nombres y no números.

## Documentar el código

Para que humanos y agentes entiendan un archivo sin leerlo entero:

- **Comentario de clase `##`** al inicio de cada script: una o dos líneas de *qué hace* y *con quién se comunica*.
- **`##` sobre cada señal, `@export` y función pública**: qué significa, unidades y rangos.
- Comenta el **porqué**, no el qué. Lo obvio no se comenta.
- Comentarios de código en **inglés** (como el resto del código); los documentos de `docs/` en español.

```gdscript
## Heroine controller. Reads movement input and moves the body.
## Talks to: nothing yet (the virtual joystick will feed `Input` actions).
class_name Player
extends CharacterBody2D

## Movement speed in pixels per second.
@export var speed: float = 300.0
```

## Flujo de trabajo

- Ramas `feat/...`, `fix/...`, `chore/...`; `main` siempre abre sin errores.
- Commits con Conventional Commits.
- Tras cambiar código, validar: `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --quit`.
- Decisiones relevantes → ADR en `docs/adr/`.
