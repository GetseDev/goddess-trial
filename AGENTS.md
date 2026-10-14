# AGENTS.md — Goddess's Trial

Guía para agentes de IA (Claude Code, Codex, Cursor, etc.) y colaboradores que trabajen en este repositorio. Léela completa antes de hacer cambios.

## Idioma

- Comunícate con el autor en **español**.
- Código, nombres de archivos, nodos, variables, señales y mensajes de commit en **inglés**.
- Los documentos de diseño y las decisiones (`docs/`) se escriben en español.

## Visión del juego

**Goddess's Trial** es un juego 2D para **Android**, monetizado con anuncios recompensados (AdMob) y compras dentro de la app (skins, quitar anuncios).

Es un **híbrido entre survivor y Hades**:

- **Combate tipo survivor:** la heroína ataca automáticamente y el jugador solo la mueve con un joystick virtual. Se juega con un dedo.
- **Estructura tipo Hades:** la partida se divide en **salas** de 60 a 90 segundos de supervivencia. Al terminar cada sala aparecen 2 o 3 **puertas**, y cada una muestra la recompensa que hay detrás (bendición de una diosa, monedas, curación, jefe...).
- **Una sola protagonista:** una mortal que busca ascender a diosa.
- **Bendiciones de las diosas:** al subir de nivel o elegir una puerta, varias diosas (retratos ilustrados) ofrecen poderes. Combinar bendiciones de dos diosas desbloquea **combos secretos** (p. ej. Fuego + Hielo = vapor que ciega).
- **Transformación divina (ultimate):** se llena una barra de "fe" durante la partida. Al activarla, la heroína se transforma en diosa unos 10 segundos (más grande, invencible, daño masivo). Su forma depende de la bendición dominante.
- **Santuario (meta-progresión):** al morir, el jugador vuelve a un hub donde gasta lo ganado en mejoras permanentes y donde las diosas le hablan.
- **Más adelante (no en el MVP):** sistema de afinidad con las diosas (diálogos, ilustraciones, atuendos).

### Alcance del MVP

No añadas nada fuera de esta lista sin que el autor lo pida:

- 1 heroína jugable
- 3 o 4 diosas con sus bendiciones y al menos 2 combos
- 1 bioma con unas 8 salas por partida y un jefe final
- La transformación divina
- Un santuario con unas pocas mejoras permanentes
- Pantalla **vertical**, controles táctiles con una mano

### Contenido y arte

- Estilo anime atractivo pero **apto para anuncios**: nada explícito ni sexualmente sugerente. Google Play y AdMob penalizan o rechazan ese contenido.
- Mientras se prototipa se usan **formas y colores placeholder**. El arte final llega cuando la jugabilidad esté validada.

## Stack técnico

- **Motor:** Godot **4.7**, renderer **Mobile**.
- **Lenguaje:** **GDScript** con tipado estático. No uses C# (complica la exportación a Android).
- **Plataforma:** Android (AAB para Play Store). Durante el desarrollo también se prueba en escritorio.
- **Física:** 2D integrada de Godot. La línea de Jolt en `project.godot` es solo para 3D y no afecta al juego.

## Estructura del proyecto

Estructura objetivo. Créala a medida que haga falta y no generes carpetas vacías:

```
res://
├── AGENTS.md
├── project.godot
├── docs/
│   ├── design/            # Documento de diseño, listas de bendiciones, balance
│   └── adr/               # Registros de decisiones (0001-titulo.md)
├── scenes/
│   ├── main/              # Escena raíz, menús
│   ├── player/
│   ├── enemies/
│   ├── rooms/             # Salas y puertas
│   ├── sanctuary/
│   └── ui/                # HUD, joystick, pantalla de bendiciones
├── scripts/
│   ├── autoload/          # Singletons (GameState, RunManager, SaveManager...)
│   └── components/        # Componentes reutilizables (HealthComponent, Hitbox...)
├── resources/
│   ├── goddesses/         # GoddessData (.tres)
│   ├── blessings/         # BlessingData (.tres)
│   └── enemies/           # EnemyData (.tres)
├── assets/
│   ├── art/
│   ├── audio/
│   └── fonts/
└── tests/
```

Cada script vive junto a su escena (`scenes/player/player.tscn` + `scenes/player/player.gd`), salvo los autoloads y los componentes compartidos, que van en `scripts/`.

## Convenciones de código

Sigue la [guía de estilo oficial de GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html):

- Archivos y carpetas en `snake_case`. Clases (`class_name`) y nodos en `PascalCase`.
- Variables y funciones en `snake_case`; constantes en `UPPER_SNAKE_CASE`; señales en pasado (`died`, `level_up_reached`).
- **Tipado estático siempre:** `var speed: float = 200.0`, `func take_damage(amount: int) -> void:`.
- Usa `@export` para los valores ajustables desde el editor y `@onready` para las referencias a nodos.
- Indentación con **tabs** (el estándar de Godot).
- Comunicación entre sistemas mediante **señales**. Evita rutas largas como `get_node("../../X")`.
- Los datos de juego (diosas, bendiciones, enemigos, mejoras) se definen como **Resources** (`.tres`), no hardcodeados en scripts. Así se pueden balancear sin tocar código.
- Prefiere la composición (nodos componente) a jerarquías de herencia profundas.

## Rendimiento (móvil)

Un survivor puede llegar a cientos de enemigos en pantalla. Ten en cuenta lo siguiente:

- Usa **object pooling** para enemigos, proyectiles y gemas de XP. No hagas `instantiate()`/`queue_free()` en bucles calientes.
- Para enemigos simples, prefiere `Area2D` o movimiento manual a `CharacterBody2D` con `move_and_slide()`, y configura las capas y máscaras de colisión con cuidado.
- Evita trabajo por frame innecesario en `_process`. Usa temporizadores o actualizaciones escalonadas.
- Si los enemigos superan los ~300 en pantalla, evalúa `MultiMeshInstance2D` o un servidor de física directo (`PhysicsServer2D`).
- Objetivo: **60 FPS estables en un Android de gama media**.

## Monetización (cuando llegue el momento)

- Anuncios **recompensados** únicamente en puntos opcionales: revivir, duplicar la recompensa de la partida, cofre extra en el santuario.
- Nada de anuncios intersticiales en mitad de una sala.
- Encapsula los anuncios y las compras detrás de un autoload (`AdsManager`, `StoreManager`) con una implementación simulada (mock) para escritorio.

## Flujo de trabajo y DevOps

El proyecto también sirve para practicar DevOps y la toma de decisiones. Trátalo como un producto real.

- **Git:** la rama `main` siempre debe abrir y ejecutarse sin errores. Trabaja en ramas `feat/...`, `fix/...` o `chore/...`.
- **Commits:** [Conventional Commits](https://www.conventionalcommits.org/) (`feat: add door selection after room clear`).
- **Versionado:** SemVer con tags (`v0.1.0`). El `version/code` de Android debe incrementarse en cada release.
- **Decisiones:** cualquier decisión relevante de diseño o arquitectura se documenta como ADR en `docs/adr/NNNN-titulo.md` (contexto, decisión, alternativas descartadas, consecuencias).
- **CI/CD (planeado):** GitHub Actions para exportar el build de Android en cada push y subirlo a la pista *internal* de Play Console en cada tag.
- **Secretos:** el **keystore** de firma, sus contraseñas y cualquier clave de API **nunca** se suben al repositorio. Van en secretos de CI o en archivos ignorados por git (`export_credentials.cfg`, `*.keystore`, `*.jks`).

## Reglas para agentes

1. **No edites** nada dentro de `.godot/` (es caché generada) ni los archivos `*.import`.
2. Prefiere editar `project.godot` mediante el editor. Si tienes que tocarlo a mano, haz cambios mínimos y explica cuáles.
3. Los archivos `.tscn` y `.tres` son texto, pero sus `uid` y los `ExtResource` deben mantenerse coherentes. Al crear escenas a mano, verifica que las rutas `res://` existan.
4. No cambies el alcance del MVP, el género ni las decisiones registradas en `docs/adr/` sin consultarlo con el autor.
5. No añadas plugins, addons ni dependencias externas sin preguntar.
6. Después de cambios en código, si el binario de Godot está disponible, valida que el proyecto abre sin errores:
   ```bash
   /Applications/Godot.app/Contents/MacOS/Godot --headless --path . --quit
   ```
   Si el binario no está disponible, indícalo y pide al autor que pruebe en el editor.
7. Si el MCP `godot-mcp-toolkit` está conectado (plugin en `addons/godot_mcp_toolkit`, config en `.mcp.json`), úsalo para crear escenas y nodos, ejecutar el juego, simular input y tomar capturas para verificar los cambios. No modifiques archivos del plugin.
8. Mantén este archivo actualizado cuando cambien decisiones importantes.
