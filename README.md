# Distortionz Coords

> Standalone dev laser — point a camera laser at anything and read/copy its coords (vec3 / vec4 / heading / entity).

![FiveM](https://img.shields.io/badge/FiveM-cerulean-yellow?style=flat-square&labelColor=181b20)
![License](https://img.shields.io/badge/License-MIT-brightgreen?style=flat-square)
![Version](https://img.shields.io/github/v/release/Distortionzz/Distortionz_Coords?style=flat-square&color=d4aa62&label=version)

---

## Usage

- `/coords` — toggle the laser on/off
- Point at anything — a red laser + marker shows the spot; the HUD shows
  live `X/Y/Z`, a `vec4` with your current heading, and hit-entity info
  (ped / player / vehicle / object, model, heading)
- **`E`** — copy `vec4(x, y, z, h)` (or vec3, per `Config.Tool.copyMode`)
  to clipboard; both forms also print to the F8 console

## Configuration

`config.lua` → `Config.Tool`:

| Key | Purpose |
|---|---|
| `command` | chat command (default `coords`) |
| `keybind` | optional default key for the toggle |
| `ace` | optional ace permission to restrict use (`false` = anyone) |
| `rayDist` | max laser distance |
| `decimals` | rounding in the copied string |
| `copyKey` / `copyMode` | copy control id + `vec4` or `vec3` |
| `laserColor` | laser/marker RGB |

## Dependencies

| Resource | Required | Purpose |
|---|---|---|
| `ox_lib` | yes | clipboard + notify fallback |
| `distortionz_notify` | optional | branded notifications |

## Installation

```cfg
ensure ox_lib
ensure distortionz_coords
```

## Credits

- **Author:** Distortionz

## License

MIT — see [LICENSE](LICENSE).
