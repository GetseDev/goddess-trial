<div align="center">

# ✨ Goddess's Trial ✨

**A one-thumb survivor × Hades-style roguelite for Android.**
**Un roguelite estilo survivor × Hades para Android, que se juega con un dedo.**

![Godot](https://img.shields.io/badge/Godot-4.7-478CBF?logo=godotengine&logoColor=white)
![GDScript](https://img.shields.io/badge/GDScript-typed-355570)
![Platform](https://img.shields.io/badge/platform-Android-3DDC84?logo=android&logoColor=white)
![Status](https://img.shields.io/badge/status-prototype-orange)

[🇬🇧 English](#-english) · [🇪🇸 Español](#-español)

</div>

---

## 🇬🇧 English

### About

A mortal woman wants to ascend to godhood. She fights through a series of trial rooms, and the goddesses watch, judge and lend her their power.

- **Survivor combat:** the heroine attacks automatically; you only move her with a virtual joystick. One finger, portrait screen.
- **Hades-style structure:** a run is split into rooms of 60–90 seconds. When a room is cleared, 2–3 doors appear, each showing the reward behind it (a goddess's blessing, coins, healing, a boss…).
- **Goddess blessings:** goddesses offer powers when you level up or pick a door. Mixing blessings from two goddesses unlocks secret combos (e.g. Fire + Ice = blinding steam).
- **Divine transformation:** fill the faith bar to turn into a goddess for ~10 seconds — bigger, invincible, massive damage.
- **Sanctuary:** after you fall, spend what you earned on permanent upgrades in a hub where the goddesses talk to you.

### Current status

Early prototype. All visuals are **placeholder shapes** until the gameplay is validated.

| Done ✅ | Next 🕓 |
|---|---|
| Portrait project setup (540×960, Mobile renderer) | XP gems and level-up |
| Floating touch joystick (mouse emulates touch on desktop) | Blessing selection screen |
| Heroine movement | Rooms and doors |
| Pooled chasing enemies + spawner (data-driven via `.tres`) | Faith bar and divine transformation |
| Health, contact damage and auto-attack projectiles | Final boss, sanctuary, permanent upgrades |
| HP HUD | Ads and in-app purchases (rewarded ads only) |

### MVP scope

1 playable heroine · 3–4 goddesses with blessings and at least 2 combos · 1 biome (~8 rooms + final boss) · the divine transformation · a small sanctuary with a few permanent upgrades.

### Tech stack

- **Engine:** [Godot](https://godotengine.org/) 4.7, Mobile renderer
- **Language:** GDScript with static typing
- **Target:** Android (AAB for Google Play); also playable on desktop for development
- **Design goals:** 60 FPS on a mid-range Android phone — object pooling for enemies and projectiles, game data in `Resource` files

### Run it

1. Install Godot 4.7.
2. Clone this repo and import `project.godot` in the Godot project manager.
3. Press **F5**.

Controls on desktop: arrow keys, or click and drag with the mouse (it emulates touch) to use the joystick.

### Project structure

```
scenes/       player, enemies, projectiles, UI, main scene (each script lives next to its scene)
scripts/      reusable components (ObjectPool, HealthComponent, Hurtbox, AutoAttackComponent)
resources/    data as .tres files (enemies now; goddesses and blessings later)
docs/design/  design docs — see arquitectura.md for the module map
```

The full module map is in [`docs/design/arquitectura.md`](docs/design/arquitectura.md) (in Spanish). Contributor and AI-agent guidelines are in [`AGENTS.md`](AGENTS.md).

### Content policy

Anime-style art that is safe for ads and app stores: all characters are adults, and nothing explicit or sexually suggestive.

### License

Not decided yet. Until a license is added, all rights are reserved.

---

## 🇪🇸 Español

### Acerca del juego

Una mortal quiere ascender a diosa. Atraviesa una serie de salas de prueba mientras las diosas la observan, la juzgan y le prestan su poder.

- **Combate tipo survivor:** la heroína ataca sola; tú solo la mueves con un joystick virtual. Un dedo, pantalla vertical.
- **Estructura tipo Hades:** la partida se divide en salas de 60 a 90 segundos. Al terminar cada una aparecen 2 o 3 puertas, y cada una muestra su recompensa (bendición de una diosa, monedas, curación, jefe…).
- **Bendiciones de las diosas:** las diosas ofrecen poderes al subir de nivel o al elegir una puerta. Combinar bendiciones de dos diosas desbloquea combos secretos (p. ej. Fuego + Hielo = vapor que ciega).
- **Transformación divina:** llena la barra de fe para convertirte en diosa unos 10 segundos: más grande, invencible y con daño masivo.
- **Santuario:** al caer, gastas lo ganado en mejoras permanentes en un hub donde las diosas te hablan.

### Estado actual

Prototipo temprano. Todo el apartado visual son **formas placeholder** hasta validar la jugabilidad.

| Hecho ✅ | Siguiente 🕓 |
|---|---|
| Proyecto vertical (540×960, renderer Mobile) | Gemas de XP y subida de nivel |
| Joystick táctil flotante (el ratón emula el toque en escritorio) | Pantalla de elección de bendiciones |
| Movimiento de la heroína | Salas y puertas |
| Enemigos que persiguen con pooling + spawner (datos en `.tres`) | Barra de fe y transformación divina |
| Vida, daño por contacto y proyectiles de ataque automático | Jefe final, santuario y mejoras permanentes |
| HUD con la vida | Anuncios y compras (solo anuncios recompensados) |

### Alcance del MVP

1 heroína jugable · 3 o 4 diosas con bendiciones y al menos 2 combos · 1 bioma (~8 salas y jefe final) · la transformación divina · un santuario con unas pocas mejoras permanentes.

### Stack técnico

- **Motor:** [Godot](https://godotengine.org/) 4.7, renderer Mobile
- **Lenguaje:** GDScript con tipado estático
- **Plataforma:** Android (AAB para Google Play); también se juega en escritorio durante el desarrollo
- **Objetivos de diseño:** 60 FPS en un Android de gama media: object pooling para enemigos y proyectiles, y datos de juego en archivos `Resource`

### Cómo ejecutarlo

1. Instala Godot 4.7.
2. Clona este repositorio e importa `project.godot` en el gestor de proyectos de Godot.
3. Pulsa **F5**.

Controles en escritorio: flechas del teclado, o clic y arrastre con el ratón (emula el toque) para usar el joystick.

### Estructura del proyecto

```
scenes/       jugador, enemigos, proyectiles, UI y escena principal (cada script junto a su escena)
scripts/      componentes reutilizables (ObjectPool, HealthComponent, Hurtbox, AutoAttackComponent)
resources/    datos en archivos .tres (enemigos por ahora; diosas y bendiciones más adelante)
docs/design/  documentos de diseño; el mapa de módulos está en arquitectura.md
```

El mapa completo de módulos está en [`docs/design/arquitectura.md`](docs/design/arquitectura.md). Las guías para colaboradores y agentes de IA están en [`AGENTS.md`](AGENTS.md).

### Política de contenido

Arte estilo anime apto para anuncios y tiendas de aplicaciones: todos los personajes son adultos y no hay nada explícito ni sexualmente sugerente.

### Licencia

Aún sin definir. Mientras no se añada una licencia, todos los derechos están reservados.
